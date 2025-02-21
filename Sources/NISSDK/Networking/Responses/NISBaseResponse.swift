import Foundation

struct NISBaseResponse: Decodable {
    let status: String
    let message: String?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case timestamp
    }
}
