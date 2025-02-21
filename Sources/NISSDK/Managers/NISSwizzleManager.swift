import Foundation
import UIKit

class NISSwizzleManager {
    static func swizzleNotificationMethods() {
        swizzleApplicationDelegate()
    }
    
    private static func swizzleApplicationDelegate() {
        let originalSelector = #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
        let swizzledSelector = #selector(UIApplicationDelegate.swizzled_application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
        
        guard let appDelegate = UIApplication.shared.delegate else { return }
        let appDelegateClass = type(of: appDelegate)
        
        guard let originalMethod = class_getInstanceMethod(appDelegateClass, originalSelector),
              let swizzledMethod = class_getInstanceMethod(appDelegateClass, swizzledSelector) else {
            return
        }
        
        let didAddMethod = class_addMethod(
            appDelegateClass,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddMethod {
            class_replaceMethod(
                appDelegateClass,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

extension UIApplicationDelegate {
    @objc func swizzled_application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        NISNotificationClient.shared.handleNewToken(token)
        
        // Call original implementation if it exists
        swizzled_application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    @objc func swizzled_application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        NISLogger.error("Failed to register for remote notifications: \(error)")
        
        // Call original implementation if it exists
        swizzled_application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}
