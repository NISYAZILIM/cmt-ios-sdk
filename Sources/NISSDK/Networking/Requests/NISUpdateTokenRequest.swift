import Foundation

struct NISUpdateTokenRequest: Encodable {
    let deviceToken: String
    let timestamp: Date
    
    init(deviceToken: String) {
        self.deviceToken = deviceToken
        self.timestamp = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case timestamp
    }
}
