import Foundation

struct NISAssociateUserRequest: Encodable {
    let userId: String
    let timestamp: Date
    
    init(userId: String) {
        self.userId = userId
        self.timestamp = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case timestamp
    }
}
