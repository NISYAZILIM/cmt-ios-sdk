import Foundation

enum NISNetworkError: Error {
    case notConfigured
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    case rateLimitExceeded
    case serverError(String)
    case unauthorized
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .notConfigured:
            return "SDK not properly configured. Make sure to call initialize with valid API key."
        case .invalidURL:
            return "Invalid URL in request."
        case .invalidResponse:
            return "Received invalid response from server."
        case .httpError(let code):
            return "HTTP error with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .serverError(let message):
            return "Server error: \(message)"
        case .unauthorized:
            return "Unauthorized request. Please check your API key."
        case .timeout:
            return "Request timed out. Please try again."
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .networkError, .timeout, .serverError:
            return true
        case .httpError(let code):
            return code >= 500
        default:
            return false
        }
    }
}
