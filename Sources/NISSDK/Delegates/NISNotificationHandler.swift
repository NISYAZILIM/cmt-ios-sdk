import Foundation
import UserNotifications

class NISNotificationHandlerDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        NISLogger.debug("Received notification in foreground: \(userInfo)")
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier
        
        NISLogger.debug("Handling notification response: \(actionIdentifier)")
        
        switch actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            handleDefaultAction(userInfo: userInfo)
            
        case UNNotificationDismissActionIdentifier:
            handleDismissAction(userInfo: userInfo)
            
        default:
            handleCustomAction(identifier: actionIdentifier, userInfo: userInfo)
        }
        
        completionHandler()
    }
    
    private func handleDefaultAction(userInfo: [AnyHashable: Any]) {
        guard let payload = NISNotificationPayload(userInfo: userInfo) else {
            NISLogger.error("Invalid notification payload")
            return
        }
        
        if let deepLink = payload.deepLink {
            handleDeepLink(deepLink)
        }
    }
    
    private func handleDismissAction(userInfo: [AnyHashable: Any]) {
        NISLogger.debug("Notification dismissed: \(userInfo)")
    }
    
    private func handleCustomAction(identifier: String, userInfo: [AnyHashable: Any]) {
        NISLogger.debug("Custom action: \(identifier) with payload: \(userInfo)")
    }
    
    private func handleDeepLink(_ deepLink: String) {
        guard let url = URL(string: deepLink) else {
            NISLogger.error("Invalid deep link URL: \(deepLink)")
            return
        }
        
        // Handle deep link based on URL scheme
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        NISLogger.debug("Processing deep link: \(components?.path ?? "")")
        
        // Delegate deep link handling to the app
        NotificationCenter.default.post(
            name: .NISDidReceiveDeepLink,
            object: nil,
            userInfo: ["url": url]
        )
    }
}

extension Notification.Name {
    static let NISDidReceiveDeepLink = Notification.Name("NISDidReceiveDeepLink")
}
