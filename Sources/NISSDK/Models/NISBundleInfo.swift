import Foundation

struct NISBundleInfo: Codable {
    let bundleId: String
    let appName: String
    let appVersion: String
    
    static var current: NISBundleInfo {
        let bundle = Bundle.main
        return NISBundleInfo(
            bundleId: bundle.bundleIdentifier ?? "",
            appName: bundle.infoDictionary?[kCFBundleNameKey as String] as? String ?? "",
            appVersion: bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case bundleId = "bundle_id"
        case appName = "app_name"
        case appVersion = "app_version"
    }
}
