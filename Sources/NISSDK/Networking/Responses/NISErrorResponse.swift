import Foundation

struct NISErrorResponse: Decodable {
    let status: String
    let code: String
    let message: String
    let details: [String: String]?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case status
        case code = "error_code"
        case message = "error_message"
        case details = "error_details"
        case timestamp
    }
}
