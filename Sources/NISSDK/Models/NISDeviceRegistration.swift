import Foundation

struct NISDeviceRegistration: Codable {
    let deviceId: String
    let token: String
    let defaultTopics: [String]
    let createdAt: Date
    let updatedAt: Date
    let status: DeviceStatus
    
    enum DeviceStatus: String, Codable {
        case active
        case inactive
        case blocked
    }
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
        case token = "device_token"
        case defaultTopics = "default_topics"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
    }
}
