import Foundation

class NISTokenManager {
    private let storage: NISDeviceStorage
    private let apiClient: NISAPIClient
    private let queue = DispatchQueue(label: "com.nis.token")
    
    init(storage: NISDeviceStorage, apiClient: NISAPIClient) {
        self.storage = storage
        self.apiClient = apiClient
    }
    
    func handleTokenRefresh(_ newToken: String) async throws {
        let deviceId = storage.getDeviceId()
        let currentToken = storage.getDeviceToken()
        
        if currentToken == newToken {
            return
        }
        
        if deviceId == nil {
            try await registerNewDevice(newToken)
        } else {
            try await updateToken(deviceId: deviceId!, newToken: newToken)
        }
        
        storage.saveDeviceToken(newToken)
    }
    
    private func registerNewDevice(_ token: String) async throws {
        let registration = try await apiClient.registerDevice(token: token)
        storage.saveDeviceId(registration.deviceId)
        
        if !registration.defaultTopics.isEmpty {
            try await NISTopicManager.shared.subscribeToTopics(registration.defaultTopics)
        }
    }
    
    private func updateToken(deviceId: String, newToken: String) async throws {
        try await apiClient.updateToken(deviceId: deviceId, newToken: newToken)
    }
}
