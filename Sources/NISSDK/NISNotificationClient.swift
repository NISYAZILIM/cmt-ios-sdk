import Foundation
import UserNotifications

/// Main client class for the NotificationSDK
public class NISNotificationClient {
    
    /// Shared instance of the NISNotificationClient
    public static let shared = NISNotificationClient()
    
    /// Current configuration of the client
    private var configuration: NISConfiguration?
    
    /// Managers
    private let tokenManager: NISTokenManager
    private let apiClient: NISAPIClient
    private let topicManager: NISTopicManager
    private let storage: NISDeviceStorage
    private let notificationDelegate: NISNotificationHandlerDelegate
    
    /// Private initializer to enforce singleton pattern
    private init() {
        // Get bundle info
        let bundleInfo = NISBundleInfo.current
        
        // Initialize components
        self.storage = NISDeviceStorage(namespace: bundleInfo.bundleId)
        self.apiClient = NISAPIClient(bundleInfo: bundleInfo)
        self.tokenManager = NISTokenManager(storage: storage, apiClient: apiClient)
        self.topicManager = NISTopicManager(storage: storage, apiClient: apiClient)
        self.notificationDelegate = NISNotificationHandlerDelegate()
    }
    
    /// Initialize the SDK with your API key
    /// - Parameter apiKey: Your API key from the dashboard
    public static func initialize(apiKey: String) {
        shared.apiClient.configure(apiKey: apiKey)
        
        // Set default configuration based on environment
        #if DEBUG
        shared.configuration = .debug
        #else
        shared.configuration = .production
        #endif
        
        NISLogger.configure(level: shared.configuration?.logLevel ?? .info)
        
        if #available(iOS 10.0, *) {
            setupModernNotifications()
        } else {
            setupLegacyNotifications()
        }
        
        NISSwizzleManager.swizzleNotificationMethods()
    }
    
    /// Set up notifications for iOS 10 and later
    @available(iOS 10.0, *)
    private static func setupModernNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = shared.notificationDelegate
        shared.requestNotificationPermission()
    }
    
    /// Set up notifications for iOS versions prior to 10
    private static func setupLegacyNotifications() {
        shared.requestNotificationPermission()
    }
    
    /// Handle new device token
    /// - Parameter token: The new device token
    func handleNewToken(_ token: String) {
        Task {
            do {
                try await tokenManager.handleTokenRefresh(token)
            } catch {
                NISLogger.error("Failed to handle token refresh: \(error)")
            }
        }
    }
    
    /// Associate a user with the current device
    /// - Parameter userId: The ID of the user to associate
    /// - Throws: NISNotificationError
    public func associateUser(_ userId: String) async throws {
        guard let deviceId = storage.getDeviceId() else {
            throw NISNotificationError.noDeviceId
        }
        try await apiClient.associateUser(deviceId: deviceId, userId: userId)
    }
    
    /// Remove user association from the current device
    /// - Throws: NISNotificationError
    public func removeUserAssociation() async throws {
        guard let deviceId = storage.getDeviceId() else {
            throw NISNotificationError.noDeviceId
        }
        try await apiClient.removeUserAssociation(deviceId: deviceId)
    }
    
    /// Subscribe to a topic
    /// - Parameter topic: The topic to subscribe to
    /// - Throws: NISNotificationError
    public func subscribe(to topic: String) async throws {
        try await topicManager.subscribe(to: topic)
    }
    
    /// Unsubscribe from a topic
    /// - Parameter topic: The topic to unsubscribe from
    /// - Throws: NISNotificationError
    public func unsubscribe(from topic: String) async throws {
        try await topicManager.unsubscribe(from: topic)
    }
    
    /// Request notification permissions from the user
    private func requestNotificationPermission() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            ) { [weak self] granted, error in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
                if let error = error {
                    NISLogger.error("Failed to request authorization: \(error)")
                }
                self?.handleAuthorizationResponse(granted: granted)
            }
        } else {
            let types: UIUserNotificationType = [.alert, .sound, .badge]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// Handle the response from requesting notification permissions
    /// - Parameter granted: Whether permission was granted
    private func handleAuthorizationResponse(granted: Bool) {
        if granted {
            NISLogger.info("Notification permission granted")
        } else {
            NISLogger.warning("Notification permission denied")
        }
    }
    
    /// Get the current notification settings
    /// - Returns: Current notification settings
    @available(iOS 10.0, *)
    public func getNotificationSettings() async -> UNNotificationSettings {
        await UNUserNotificationCenter.current().notificationSettings()
    }
    
    /// Check if notifications are enabled
    /// - Returns: Boolean indicating if notifications are enabled
    @available(iOS 10.0, *)
    public func areNotificationsEnabled() async -> Bool {
        let settings = await getNotificationSettings()
        return settings.authorizationStatus == .authorized
    }
    
    /// Register custom notification categories
    /// - Parameter categories: Set of notification categories
    @available(iOS 10.0, *)
    public func registerNotificationCategories(_ categories: Set<UNNotificationCategory>) {
        UNUserNotificationCenter.current().setNotificationCategories(categories)
    }
}

// MARK: - Extension for handling notification responses
@available(iOS 10.0, *)
extension NISNotificationClient {
    /// Handle notification response
    /// - Parameter response: The notification response
    /// - Parameter completionHandler: Completion handler to call when finished
    public func handleNotificationResponse(
        _ response: UNNotificationResponse,
        completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle different types of responses
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            handleDefaultAction(userInfo: userInfo)
        case UNNotificationDismissActionIdentifier:
            handleDismissAction(userInfo: userInfo)
        default:
            handleCustomAction(identifier: response.actionIdentifier, userInfo: userInfo)
        }
        
        completionHandler()
    }
    
    private func handleDefaultAction(userInfo: [AnyHashable: Any]) {
        NISLogger.debug("Handling default notification action")
        // Handle default action (app opened from notification)
    }
    
    private func handleDismissAction(userInfo: [AnyHashable: Any]) {
        NISLogger.debug("Handling notification dismiss")
        // Handle notification dismissal
    }
    
    private func handleCustomAction(identifier: String, userInfo: [AnyHashable: Any]) {
        NISLogger.debug("Handling custom action: \(identifier)")
        // Handle custom notification actions
    }
}
