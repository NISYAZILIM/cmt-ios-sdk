import Foundation

struct NISRegisterDeviceRequest: Encodable {
    let deviceToken: String
    let platform: String
    let bundleInfo: NISBundleInfo
    let deviceInfo: NISDeviceInfo
    let timestamp: Date
    
    init(deviceToken: String, platform: String, bundleInfo: NISBundleInfo, deviceInfo: NISDeviceInfo) {
        self.deviceToken = deviceToken
        self.platform = platform
        self.bundleInfo = bundleInfo
        self.deviceInfo = deviceInfo
        self.timestamp = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case platform
        case bundleId = "bundle_id"
        case appName = "app_name"
        case appVersion = "app_version"
        case deviceModel = "device_model"
        case osVersion = "os_version"
        case timestamp
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(platform, forKey: .platform)
        try container.encode(bundleInfo.bundleId, forKey: .bundleId)
        try container.encode(bundleInfo.appName, forKey: .appName)
        try container.encode(bundleInfo.appVersion, forKey: .appVersion)
        try container.encode(deviceInfo.model, forKey: .deviceModel)
        try container.encode(deviceInfo.osVersion, forKey: .osVersion)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
