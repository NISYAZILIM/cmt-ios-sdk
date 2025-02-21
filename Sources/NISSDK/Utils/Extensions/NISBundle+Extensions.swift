import Foundation

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildVersion: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var displayName: String {
        return infoDictionary?["CFBundleDisplayName"] as? String
            ?? infoDictionary?[kCFBundleNameKey as String] as? String
            ?? ""
    }
    
    var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    var versionAndBuild: String {
        return "\(appVersion) (\(buildVersion))"
    }
}
