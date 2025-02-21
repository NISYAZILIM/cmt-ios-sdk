import Foundation

struct NISDeviceRegistrationResponse: Decodable {
    let deviceId: String
    let token: String
    let defaultTopics: [String]
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case token = "device_token"
        case defaultTopics = "default_topics"
        case createdAt = "created_at"
    }
}
