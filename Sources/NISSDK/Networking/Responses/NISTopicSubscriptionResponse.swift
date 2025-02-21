import Foundation

struct NISTopicSubscriptionResponse: Decodable {
    let topic: String
    let status: String
    let subscribedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case topic
        case status
        case subscribedAt = "subscribed_at"
    }
}
