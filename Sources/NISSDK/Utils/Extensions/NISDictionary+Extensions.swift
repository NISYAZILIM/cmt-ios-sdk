import Foundation

extension Dictionary {
    func jsonData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    func jsonString() throws -> String? {
        let data = try jsonData()
        return String(data: data, encoding: .utf8)
    }
    
    mutating func merge(_ other: [Key: Value]) {
        merge(other) { current, _ in current }
    }
    
    func merged(with other: [Key: Value]) -> [Key: Value] {
        var result = self
        result.merge(other)
        return result
    }
}

extension Dictionary where Key == String {
    func snakeCased() -> [String: Value] {
        return Dictionary(uniqueKeysWithValues: map { key, value in
            (key.snakeCased(), value)
        })
    }
    
    func camelCased() -> [String: Value] {
        return Dictionary(uniqueKeysWithValues: map { key, value in
            (key.camelCased(), value)
        })
    }
}

private extension String {
    func snakeCased() -> String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(
            in: self,
            range: range,
            withTemplate: "$1_$2"
        ).lowercased() ?? self
    }
    
    func camelCased() -> String {
        let parts = self.components(separatedBy: "_")
        let camelCased = parts.enumerated().map { index, part in
            if index == 0 {
                return part.lowercased()
            }
            return part.prefix(1).uppercased() + part.dropFirst().lowercased()
        }
        return camelCased.joined()
    }
}
