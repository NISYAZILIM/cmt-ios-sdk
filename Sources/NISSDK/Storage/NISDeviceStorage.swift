import Foundation

class NISDeviceStorage {
    private let keychain: NISKeychainWrapper
    private let userDefaults: UserDefaults
    private let namespace: String
    
    init(namespace: String) {
        self.namespace = namespace
        self.keychain = NISKeychainWrapper(namespace: namespace)
        self.userDefaults = UserDefaults.standard
    }
    
    private enum Keys {
        case deviceId
        case deviceToken
        case topics
        
        func value(for namespace: String) -> String {
            switch self {
            case .deviceId:
                return "com.nis.\(namespace).deviceId"
            case .deviceToken:
                return "com.nis.\(namespace).deviceToken"
            case .topics:
                return "com.nis.\(namespace).subscribedTopics"
            }
        }
    }
    
    func getDeviceId() -> String? {
        return keychain.string(forKey: Keys.deviceId.value(for: namespace))
    }
    
    func saveDeviceId(_ deviceId: String) {
        keychain.set(deviceId, forKey: Keys.deviceId.value(for: namespace))
    }
    
    func getDeviceToken() -> String? {
        return keychain.string(forKey: Keys.deviceToken.value(for: namespace))
    }
    
    func saveDeviceToken(_ token: String) {
        keychain.set(token, forKey: Keys.deviceToken.value(for: namespace))
    }
    
    func getTopics() -> Set<String> {
        let topics = userDefaults.stringArray(forKey: Keys.topics.value(for: namespace)) ?? []
        return Set(topics)
    }
    
    func saveTopics(_ topics: Set<String>) {
        userDefaults.set(Array(topics), forKey: Keys.topics.value(for: namespace))
    }
    
    func clearAll() {
        keychain.removeObject(forKey: Keys.deviceId.value(for: namespace))
        keychain.removeObject(forKey: Keys.deviceToken.value(for: namespace))
        userDefaults.removeObject(forKey: Keys.topics.value(for: namespace))
    }
}
