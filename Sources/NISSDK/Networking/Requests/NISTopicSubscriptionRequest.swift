import Foundation

struct NISTopicSubscriptionRequest: Encodable {
    let topic: String
    let metadata: [String: String]?
    let timestamp: Date
    
    init(topic: String, metadata: [String: String]? = nil) {
        self.topic = topic
        self.metadata = metadata
        self.timestamp = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case topic
        case metadata
        case timestamp
    }
}
