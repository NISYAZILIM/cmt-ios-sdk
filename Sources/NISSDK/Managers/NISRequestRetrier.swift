import Foundation

struct NISRequestRetrier {
    let maxRetries: Int
    let retryDelay: TimeInterval
    
    init(maxRetries: Int = 3, retryDelay: TimeInterval = 1.0) {
        self.maxRetries = maxRetries
        self.retryDelay = retryDelay
    }
    
    func execute<T>(_ operation: () async throws -> T) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<maxRetries {
            do {
                return try await operation()
            } catch let error as NISNetworkError {
                lastError = error
                
                guard error.isRetryable && attempt < maxRetries - 1 else {
                    throw error
                }
                
                try await Task.sleep(nanoseconds: UInt64(retryDelay * pow(2.0, Double(attempt)) * 1_000_000_000))
            } catch {
                throw error
            }
        }
        
        throw lastError ?? NISNetworkError.networkError(NSError(domain: "", code: -1))
    }
}

private extension NISRequestRetrier {
    func shouldRetry(_ error: Error, attempt: Int) -> Bool {
        guard attempt < maxRetries - 1 else { return false }
        
        if let networkError = error as? NISNetworkError {
            return networkError.isRetryable
        }
        
        return false
    }
}
