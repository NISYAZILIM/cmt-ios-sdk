import Foundation
import UIKit

struct NISDeviceInfo: Codable {
    let model: String
    let osVersion: String
    let platform: String
    let timezone: String
    let language: String
    
    static var current: NISDeviceInfo {
        NISDeviceInfo(
            model: UIDevice.current.model,
            osVersion: UIDevice.current.systemVersion,
            platform: "iOS",
            timezone: TimeZone.current.identifier,
            language: Locale.current.languageCode ?? "en"
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case model = "device_model"
        case osVersion = "os_version"
        case platform
        case timezone
        case language
    }
}
