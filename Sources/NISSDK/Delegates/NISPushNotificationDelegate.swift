import Foundation
import UserNotifications

public protocol NISPushNotificationDelegate: AnyObject {
    func notificationReceived(_ notification: NISNotificationPayload)
    func notificationOpened(_ notification: NISNotificationPayload)
    func notificationDismissed(_ notification: NISNotificationPayload)
    func notificationButtonClicked(_ notification: NISNotificationPayload, buttonIdentifier: String)
    func deepLinkReceived(_ url: URL)
}

// Default implementations
public extension NISPushNotificationDelegate {
    func notificationReceived(_ notification: NISNotificationPayload) {}
    func notificationOpened(_ notification: NISNotificationPayload) {}
    func notificationDismissed(_ notification: NISNotificationPayload) {}
    func notificationButtonClicked(_ notification: NISNotificationPayload, buttonIdentifier: String) {}
    func deepLinkReceived(_ url: URL) {}
}

@available(iOS 10.0, *)
class NISPushNotificationDelegateWrapper: NSObject {
    weak var delegate: NISPushNotificationDelegate?
    
    init(delegate: NISPushNotificationDelegate?) {
        self.delegate = delegate
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeepLink(_:)),
            name: .NISDidReceiveDeepLink,
            object: nil
        )
    }
    
    @objc private func handleDeepLink(_ notification: Notification) {
        guard let url = notification.userInfo?["url"] as? URL else { return }
        delegate?.deepLinkReceived(url)
    }
    
    func handleNotificationReceived(_ payload: NISNotificationPayload) {
        delegate?.notificationReceived(payload)
    }
    
    func handleNotificationOpened(_ payload: NISNotificationPayload) {
        delegate?.notificationOpened(payload)
    }
    
    func handleNotificationDismissed(_ payload: NISNotificationPayload) {
        delegate?.notificationDismissed(payload)
    }
    
    func handleNotificationButtonClicked(_ payload: NISNotificationPayload, buttonIdentifier: String) {
        delegate?.notificationButtonClicked(payload, buttonIdentifier: buttonIdentifier)
    }
}
