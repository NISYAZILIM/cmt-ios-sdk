import Foundation

class NISLogger {
    static var logLevel: NISLogLevel = .info
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    static func configure(level: NISLogLevel) {
        logLevel = level
    }
    
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message: message, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message: message, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message: message, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message: message, file: file, function: function, line: line)
    }
    
    private static func log(_ level: NISLogLevel, message: String, file: String, function: String, line: Int) {
        guard level.rawValue >= logLevel.rawValue else { return }
        
        let timestamp = dateFormatter.string(from: Date())
        let filename = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level.description)] [\(filename):\(line)] \(function) - \(message)"
        
        #if DEBUG
        print(logMessage)
        #endif
        
        if level == .error {
            // Could add crash reporting or analytics here
            sendErrorToAnalytics(logMessage)
        }
    }
    
    private static func sendErrorToAnalytics(_ message: String) {
        // Integration point for crash reporting or analytics service
    }
} e
