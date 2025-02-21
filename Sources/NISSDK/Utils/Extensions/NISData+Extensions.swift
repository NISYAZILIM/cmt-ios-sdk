import Foundation

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", $0) }.joined()
    }
    
    func toString(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
    
    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
