# NotificationSDK for iOS

A lightweight, easy-to-integrate push notification SDK for iOS applications that simplifies push notification handling, device management, and topic subscriptions.

## Features

- ✨ One-line initialization
- 🔄 Automatic APNS token management
- 👥 Multi-user & multi-device support
- 📱 Works across multiple apps on same device
- 📬 Topic-based notification system
- 🔒 Secure token storage
- 🌟 iOS 11.0+ support
- ⚡️ Background token refresh
- 🔗 Deep linking support
- 📊 Rich notification support

## Requirements

- iOS 11.0+
- Swift 5.5+
- Xcode 13+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/NISYAZILIM/cmt-ios-sdk.git", from: "1.0.0")
]
```

### CocoaPods

Add the following to your Podfile:

```ruby
pod 'NotificationSDK'
```

## Quick Start Guide

### 1. Initialize the SDK

Add the following to your AppDelegate:

```swift
import NotificationSDK

func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NotificationClient.initialize(apiKey: "your-api-key")
    return true
}
```

### 2. User Management

```swift
// Associate user with device
try await NotificationClient.shared.associateUser("user_123")

// Remove user association on logout
try await NotificationClient.shared.removeUserAssociation()
```

### 3. Topic Management

```swift
// Subscribe to topics
try await NotificationClient.shared.subscribe(to: "news")

// Unsubscribe from topics
try await NotificationClient.shared.unsubscribe(from: "promotions")
```

## Advanced Usage

### Handle Deep Links

```swift
func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let userInfo = response.notification.request.content.userInfo

    if let deepLink = userInfo["deep_link"] as? String {
        // Handle deep link
    }

    completionHandler()
}
```

### Rich Notifications

```json
{
  "aps": {
    "alert": {
      "title": "New Offer!",
      "body": "Check out our latest promotion"
    },
    "sound": "default"
  },
  "deep_link": "myapp://offers/summer",
  "custom_data": {
    "offer_id": "123",
    "type": "seasonal"
  }
}
```

## Best Practices

1. Always initialize the SDK at app launch
2. Handle error cases appropriately
3. Update topic subscriptions when user preferences change
4. Remove user associations on logout
5. Implement proper deep link handling
6. Test notifications in development environment first

## Error Handling

The SDK provides detailed error types:

```swift
do {
    try await NotificationClient.shared.subscribe(to: "news")
} catch NotificationError.noDeviceId {
    // Handle missing device registration
} catch NotificationError.networkError(let error) {
    // Handle network issues
} catch {
    // Handle other errors
}
```

## Debugging

Enable debug logging:

```swift
NotificationClient.initialize(
    apiKey: "your-api-key",
    config: Configuration(logLevel: .debug)
)
```

## Migration Guide

### Upgrading from 1.x to 2.x

1. Update initialization method
2. Migrate to new error handling
3. Update topic management calls
4. Review deep link handling

## Support

- 📚 [Documentation](https://docs.yourcompany.com/notification-sdk)
- 💬 [Discord Community](https://discord.gg/yourcompany)
- 📧 [Email Support](mailto:support@yourcompany.com)
- 🐛 [Issue Tracker](https://github.com/yourcompany/notification-sdk-ios/issues)

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## Example App

Check out our example project in the [Example](Example/) directory for a complete implementation.

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for all release information.
