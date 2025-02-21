import Foundation

class NISAPIClient {
    private var apiKey: String?
    private let bundleInfo: NISBundleInfo
    private let session: URLSession
    private let retrier: NISRequestRetrier
    
    init(bundleInfo: NISBundleInfo) {
        self.bundleInfo = bundleInfo
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
        self.retrier = NISRequestRetrier(maxRetries: 3, retryDelay: 1.0)
    }
    
    func configure(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func registerDevice(token: String) async throws -> NISDeviceRegistration {
        let body = NISRegisterDeviceRequest(
            deviceToken: token,
            platform: "ios",
            bundleInfo: bundleInfo,
            deviceInfo: NISDeviceInfo.current
        )
        
        return try await performRequest(endpoint: .registerDevice, body: body)
    }
    
    func updateToken(deviceId: String, newToken: String) async throws {
        let body = NISUpdateTokenRequest(deviceToken: newToken)
        try await performRequest(endpoint: .updateToken(deviceId: deviceId), body: body)
    }
    
    func associateUser(deviceId: String, userId: String) async throws {
        let body = NISAssociateUserRequest(userId: userId)
        try await performRequest(endpoint: .associateUser(deviceId: deviceId), body: body)
    }
    
    func removeUserAssociation(deviceId: String) async throws {
        try await performRequest(endpoint: .removeUserAssociation(deviceId: deviceId))
    }
    
    private func performRequest<T: Decodable>(endpoint: NISEndpoint, body: Encodable? = nil) async throws -> T {
        guard let apiKey = apiKey else {
            throw NISNetworkError.notConfigured
        }
        
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return try await retrier.execute {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NISNetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NISNetworkError.httpError(httpResponse.statusCode)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}
