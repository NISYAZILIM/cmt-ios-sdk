import Foundation

extension String {
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
    
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    var isValidTopic: Bool {
        let pattern = "^[a-zA-Z0-9-_.]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        return regex?.firstMatch(in: self, range: range) != nil
    }
    
    var isValidDeviceToken: Bool {
        let pattern = "^[a-fA-F0-9]{64}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        return regex?.firstMatch(in: self, range: range) != nil
    }
    
    func toData(encoding: String.Encoding = .utf8) -> Data? {
        return data(using: encoding)
    }
    
    func toJSON() -> [String: Any]? {
        guard let data = toData(),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}

// MARK: - Validation Extensions
extension String {
    var isValidBundleId: Bool {
        let pattern = "^[a-zA-Z0-9.-]+\\.[a-zA-Z0-9.-]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        return regex?.firstMatch(in: self, range: range) != nil
    }
    
    var isValidAPIKey: Bool {
        let pattern = "^nis_[a-zA-Z0-9]{32}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        return regex?.firstMatch(in: self, range: range) != nil
    }
}
