# Getting Started with NISSDK

## Overview

NISSDK is a lightweight iOS push notification integration library that provides easy handling of device tokens, user associations, and topic management.

## Prerequisites

- iOS 11.0 or later
- Xcode 13.0 or later
- Valid Apple Push Notification Service (APNS) certificate
- API key from NIS dashboard

## Installation

### Swift Package Manager

Add the package dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourcompany/notification-sdk-ios.git", from: "1.0.0")
]
```

### CocoaPods

Add to your Podfile:

```ruby
pod 'NISSDK'
```

## Basic Setup

1. Initialize the SDK in your AppDelegate:

```swift
import NISSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    NISNotificationClient.initialize(apiKey: "your-api-key")
    return true
}
```

2. Request notification permissions:

```swift
NISNotificationClient.shared.requestNotificationPermission()
```

## User Management

Associate a user with the device:

```swift
try await NISNotificationClient.shared.associateUser("user_123")
```

Remove user association:

```swift
try await NISNotificationClient.shared.removeUserAssociation()
```

## Topic Management

Subscribe to topics:

```swift
try await NISNotificationClient.shared.subscribe(to: "news")
```

Unsubscribe from topics:

```swift
try await NISNotificationClient.shared.unsubscribe(from: "promotions")
```

## Handling Notifications

Implement the delegate methods:

```swift
extension YourViewController: NISPushNotificationDelegate {
    func notificationReceived(_ notification: NISNotificationPayload) {
        // Handle received notification
    }

    func notificationOpened(_ notification: NISNotificationPayload) {
        // Handle opened notification
    }

    func deepLinkReceived(_ url: URL) {
        // Handle deep link
    }
}
```

## Next Steps

- Check out [Configuration Guide](Configuration.md) for advanced settings
- Learn about [Deep Linking](DeepLinking.md)
- View the complete [API Reference](APIReference.md)
