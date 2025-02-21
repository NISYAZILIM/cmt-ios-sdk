import Foundation

class NISTopicManager {
    static let shared = NISTopicManager()
    
    private let storage: NISDeviceStorage
    private let apiClient: NISAPIClient
    private let queue = DispatchQueue(label: "com.nis.topic")
    
    init(storage: NISDeviceStorage, apiClient: NISAPIClient) {
        self.storage = storage
        self.apiClient = apiClient
    }
    
    func subscribe(to topic: String) async throws {
        guard let deviceId = storage.getDeviceId() else {
            throw NISNotificationError.noDeviceId
        }
        
        try await apiClient.performRequest(endpoint: .subscribeTopic(deviceId: deviceId, topic: topic))
        
        var topics = storage.getTopics()
        topics.insert(topic)
        storage.saveTopics(topics)
    }
    
    func unsubscribe(from topic: String) async throws {
        guard let deviceId = storage.getDeviceId() else {
            throw NISNotificationError.noDeviceId
        }
        
        try await apiClient.performRequest(endpoint: .unsubscribeTopic(deviceId: deviceId, topic: topic))
        
        var topics = storage.getTopics()
        topics.remove(topic)
        storage.saveTopics(topics)
    }
    
    func subscribeToTopics(_ topics: [String]) async throws {
        for topic in topics {
            try await subscribe(to: topic)
        }
    }
    
    func unsubscribeFromTopics(_ topics: [String]) async throws {
        for topic in topics {
            try await unsubscribe(from: topic)
        }
    }
    
    func getSubscribedTopics() -> Set<String> {
        return storage.getTopics()
    }
    
    func clearAllTopics() {
        storage.saveTopics([])
    }
}
