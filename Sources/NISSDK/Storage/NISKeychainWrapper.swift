import Foundation
import Security

class NISKeychainWrapper {
    private let namespace: String
    
    init(namespace: String) {
        self.namespace = namespace
    }
    
    private func makeQuery(forKey key: String) -> [String: Any] {
        let prefixedKey = "\(namespace).\(key)"
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: prefixedKey,
            kSecAttrService as String: "NISKeychain"
        ]
    }
    
    func string(forKey key: String) -> String? {
        var query = makeQuery(forKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return string
    }
    
    func set(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }
        
        let query = makeQuery(forKey: key)
        let attributes: [String: Any] = [
            kSecValueData as String: data
        ]
        
        var status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        if status == errSecItemNotFound {
            var query = makeQuery(forKey: key)
            query[kSecValueData as String] = data
            status = SecItemAdd(query as CFDictionary, nil)
        }
        
        if status != errSecSuccess {
            NISLogger.error("Keychain save error: \(status)")
        }
    }
    
    func removeObject(forKey key: String) {
        let query = makeQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            NISLogger.error("Keychain delete error: \(status)")
        }
    }
    
    func removeAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "NISKeychain"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            NISLogger.error("Keychain clear error: \(status)")
        }
    }
}
