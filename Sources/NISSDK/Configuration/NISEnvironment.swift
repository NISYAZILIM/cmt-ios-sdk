import Foundation

/// Environment configuration for the NISSDK
public enum NISEnvironment {
    /// Development environment
    case development
    
    /// Staging environment
    case staging
    
    /// Production environment
    case production
    
    /// Custom environment with specific configuration
    case custom(NISEnvironmentConfiguration)
}

/// Configuration for custom environments
public struct NISEnvironmentConfiguration {
    /// Base URL for API requests
    let baseURL: URL
    
    /// API version to use
    let apiVersion: String
    
    /// Additional headers to include in requests
    let additionalHeaders: [String: String]
    
    /// Whether to use SSL certificate pinning
    let useSSLPinning: Bool
    
    public init(
        baseURL: URL,
        apiVersion: String = "v1",
        additionalHeaders: [String: String] = [:],
        useSSLPinning: Bool = true
    ) {
        self.baseURL = baseURL
        self.apiVersion = apiVersion
        self.additionalHeaders = additionalHeaders
        self.useSSLPinning = useSSLPinning
    }
}

extension NISEnvironment {
    /// Base URL for the environment
    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://dev-api.notification.dev")!
        case .staging:
            return URL(string: "https://staging-api.notification.dev")!
        case .production:
            return URL(string: "https://api.notification.com")!
        case .custom(let config):
            return config.baseURL
        }
    }
    
    /// API version for the environment
    var apiVersion: String {
        switch self {
        case .custom(let config):
            return config.apiVersion
        default:
            return "v1"
        }
    }
    
    /// Additional headers for the environment
    var additionalHeaders: [String: String] {
        switch self {
        case .custom(let config):
            return config.additionalHeaders
        default:
            return [:]
        }
    }
    
    /// Whether to use SSL pinning
    var useSSLPinning: Bool {
        switch self {
        case .development:
            return false
        case .staging:
            return true
        case .production:
            return true
        case .custom(let config):
            return config.useSSLPinning
        }
    }
    
    /// Whether this is a development environment
    var isDevelopment: Bool {
        switch self {
        case .development, .staging:
            return true
        case .production, .custom:
            return false
        }
    }
    
    /// API endpoint builder
    func endpoint(path: String) -> URL {
        baseURL
            .appendingPathComponent(apiVersion)
            .appendingPathComponent(path)
    }
}

// MARK: - Helper Extensions
extension NISEnvironment: Equatable {
    public static func == (lhs: NISEnvironment, rhs: NISEnvironment) -> Bool {
        switch (lhs, rhs) {
        case (.development, .development),
             (.staging, .staging),
             (.production, .production):
            return true
        case (.custom(let lhsConfig), .custom(let rhsConfig)):
            return lhsConfig.baseURL == rhsConfig.baseURL &&
                   lhsConfig.apiVersion == rhsConfig.apiVersion
        default:
            return false
        }
    }
}

extension NISEnvironment: CustomStringConvertible {
    public var description: String {
        switch self {
        case .development:
            return "Development"
        case .staging:
            return "Staging"
        case .production:
            return "Production"
        case .custom:
            return "Custom"
        }
    }
}
