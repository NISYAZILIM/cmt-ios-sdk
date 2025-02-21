import Foundation

struct NISNotificationPayload: Codable {
    let id: String
    let title: String
    let body: String
    let data: [String: String]?
    let imageUrl: String?
    let deepLink: String?
    let sound: String?
    let badge: Int?
    let category: String?
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case data
        case imageUrl = "image_url"
        case deepLink = "deep_link"
        case sound
        case badge
        case category
        case timestamp
    }
    
    var userInfo: [AnyHashable: Any] {
        var info: [AnyHashable: Any] = [
            "id": id,
            "title": title,
            "body": body,
            "timestamp": timestamp
        ]
        
        if let data = data {
            info["data"] = data
        }
        
        if let imageUrl = imageUrl {
            info["image_url"] = imageUrl
        }
        
        if let deepLink = deepLink {
            info["deep_link"] = deepLink
        }
        
        return info
    }
}

extension NISNotificationPayload {
    init?(userInfo: [AnyHashable: Any]) {
        guard let id = userInfo["id"] as? String,
              let title = userInfo["title"] as? String,
              let body = userInfo["body"] as? String,
              let timestamp = userInfo["timestamp"] as? Date else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.data = userInfo["data"] as? [String: String]
        self.imageUrl = userInfo["image_url"] as? String
        self.deepLink = userInfo["deep_link"] as? String
        self.sound = userInfo["sound"] as? String
        self.badge = userInfo["badge"] as? Int
        self.category = userInfo["category"] as? String
    }
}
