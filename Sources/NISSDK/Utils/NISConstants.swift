import Foundation

enum NISConstants {
    enum Storage {
        static let keychainService = "NISKeychain"
        static let keychainAccessGroup = "com.nis.notification"
        static let userDefaultsSuite = "com.nis.notification"
    }
    
    enum Network {
        static let timeoutInterval: TimeInterval = 30
        static let maxRetryAttempts = 3
        static let baseRetryDelay: TimeInterval = 1.0
        static let maxRetryDelay: TimeInterval = 30.0
    }
    
    enum Cache {
        static let maxAge: TimeInterval = 3600 // 1 hour
        static let maxSize = 10 * 1024 * 1024 // 10MB
    }
    
    enum Notification {
        static let defaultTopics = ["ios", "all"]
        static let defaultCategory = "default"
        static let defaultSound = "default"
        static let maxBadgeCount = 999
    }
    
    enum Headers {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let userAgent = "User-Agent"
        static let apiVersion = "X-API-Version"
    }
    
    enum ContentType {
        static let json = "application/json"
        static let formUrlEncoded = "application/x-www-form-urlencoded"
    }
    
    enum Error {
        static let domain = "com.nis.notification"
        static let unknownErrorCode = -1
        static let networkErrorCode = -1000
        static let invalidResponseCode = -1001
        static let decodingErrorCode = -1002
        static let unauthorizedErrorCode = -1003
    }
    
    enum Analytics {
        static let eventPrefix = "nis_"
        static let maxEventNameLength = 40
        static let maxParameterCount = 25
    }
    
    enum Version {
        static let minimumOSVersion = "11.0"
        static let sdkVersion = "1.0.0"
    }
    
    enum DeepLink {
        static let scheme = "nis"
        static let host = "notification"
    }
}

extension NISConstants {
    static var userAgent: String {
        let info = NISBundleInfo.current
        return "NIS/\(Version.sdkVersion) (\(info.bundleId); \(info.appVersion))"
    }
    
    static var defaultHeaders: [String: String] {
        [
            Headers.contentType: ContentType.json,
            Headers.accept: ContentType.json,
            Headers.userAgent: userAgent,
            Headers.apiVersion: "1.0"
        ]
    }
}
