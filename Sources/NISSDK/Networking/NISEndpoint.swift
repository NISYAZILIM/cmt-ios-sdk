import Foundation

enum NISEndpoint {
    case registerDevice
    case updateToken(deviceId: String)
    case associateUser(deviceId: String)
    case removeUserAssociation(deviceId: String)
    case subscribeTopic(deviceId: String, topic: String)
    case unsubscribeTopic(deviceId: String, topic: String)
    
    var url: URL {
        let baseURL = NISEnvironment.current.baseURL
        
        switch self {
        case .registerDevice:
            return baseURL.appendingPathComponent("/devices")
            
        case .updateToken(let deviceId):
            return baseURL.appendingPathComponent("/devices/\(deviceId)/token")
            
        case .associateUser(let deviceId):
            return baseURL.appendingPathComponent("/devices/\(deviceId)/user")
            
        case .removeUserAssociation(let deviceId):
            return baseURL.appendingPathComponent("/devices/\(deviceId)/user")
            
        case .subscribeTopic(let deviceId, let topic):
            return baseURL.appendingPathComponent("/devices/\(deviceId)/topics/\(topic)")
            
        case .unsubscribeTopic(let deviceId, let topic):
            return baseURL.appendingPathComponent("/devices/\(deviceId)/topics/\(topic)")
        }
    }
    
    var method: String {
        switch self {
        case .registerDevice:
            return "POST"
        case .updateToken:
            return "PUT"
        case .associateUser:
            return "POST"
        case .removeUserAssociation:
            return "DELETE"
        case .subscribeTopic:
            return "POST"
        case .unsubscribeTopic:
            return "DELETE"
        }
    }
}
