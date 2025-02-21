import Foundation

/// Configuration options for the NISSDK
public struct NISConfiguration {
    /// The environment to use (development/production)
    let environment: NISEnvironment
    
    /// Log level for SDK operations
    let logLevel: NISLogLevel
    
    /// Whether to automatically register for default topics
    let autoRegisterDefaultTopics: Bool
    
    /// Maximum retry attempts for network operations
    let maxRetryAttempts: Int
    
    /// Timeout interval for network requests
    let timeoutInterval: TimeInterval
    
    /// Whether to automatically handle token refresh
    let automaticTokenRefresh: Bool
    
    /// Cache configuration
    let cacheConfig: NISCacheConfiguration
    
    /// Creates a new configuration with the specified parameters
    public init(
        environment: NISEnvironment = .production,
        logLevel: NISLogLevel = .info,
        autoRegisterDefaultTopics: Bool = true,
        maxRetryAttempts: Int = 3,
        timeoutInterval: TimeInterval = 30.0,
        automaticTokenRefresh: Bool = true,
        cacheConfig: NISCacheConfiguration = .default
    ) {
        self.environment = environment
        self.logLevel = logLevel
        self.autoRegisterDefaultTopics = autoRegisterDefaultTopics
        self.maxRetryAttempts = maxRetryAttempts
        self.timeoutInterval = timeoutInterval
        self.automaticTokenRefresh = automaticTokenRefresh
        self.cacheConfig = cacheConfig
    }
}

// MARK: - Default Configurations
public extension NISConfiguration {
    /// Default debug configuration
    static let debug = NISConfiguration(
        environment: .development,
        logLevel: .debug,
        autoRegisterDefaultTopics: true,
        maxRetryAttempts: 1,
        timeoutInterval: 60.0,
        automaticTokenRefresh: true,
        cacheConfig: .debug
    )
    
    /// Default production configuration
    static let production = NISConfiguration(
        environment: .production,
        logLevel: .info,
        autoRegisterDefaultTopics: true,
        maxRetryAttempts: 3,
        timeoutInterval: 30.0,
        automaticTokenRefresh: true,
        cacheConfig: .production
    )
}

/// Cache configuration for the SDK
public struct NISCacheConfiguration {
    /// Maximum age of cached data
    let maxAge: TimeInterval
    
    /// Whether to persist cache between app launches
    let persistBetweenLaunches: Bool
    
    /// Maximum size of the cache in bytes
    let maxSize: Int
    
    public static let `default` = NISCacheConfiguration(
        maxAge: 3600,
        persistBetweenLaunches: true,
        maxSize: 10 * 1024 * 1024 // 10MB
    )
    
    static let debug = NISCacheConfiguration(
        maxAge: 300,
        persistBetweenLaunches: false,
        maxSize: 5 * 1024 * 1024 // 5MB
    )
    
    static let production = NISCacheConfiguration(
        maxAge: 3600,
        persistBetweenLaunches: true,
        maxSize: 20 * 1024 * 1024 // 20MB
    )
}

/// Log levels for the SDK
public enum NISLogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    
    var description: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        }
    }
}
