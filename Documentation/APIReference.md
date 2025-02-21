# API Reference

## NISNotificationClient

Main interface for the SDK.

### Initialization

```swift
static func initialize(apiKey: String)
```

### User Management

```swift
func associateUser(_ userId: String) async throws
func removeUserAssociation() async throws
```

### Topic Management

```swift
func subscribe(to topic: String) async throws
func unsubscribe(from topic: String) async throws
```

### Notification Permissions

```swift
func requestNotificationPermission()
func areNotificationsEnabled() async -> Bool
```

## NISConfiguration

Configuration options for the SDK.

```swift
struct NISConfiguration {
    let environment: NISEnvironment
    let logLevel: NISLogLevel
    let autoRegisterDefaultTopics: Bool
    let maxRetryAttempts: Int
    let timeoutInterval: TimeInterval
    let automaticTokenRefresh: Bool
    let cacheConfig: NISCacheConfiguration
}
```

## NISEnvironment

Environment configuration.

```swift
enum NISEnvironment {
    case development
    case staging
    case production
    case custom(NISEnvironmentConfiguration)
}
```

## NISPushNotificationDelegate

Delegate protocol for handling notifications.

```swift
protocol NISPushNotificationDelegate: AnyObject {
    func notificationReceived(_ notification: NISNotificationPayload)
    func notificationOpened(_ notification: NISNotificationPayload)
    func notificationDismissed(_ notification: NISNotificationPayload)
    func notificationButtonClicked(_ notification: NISNotificationPayload, buttonIdentifier: String)
    func deepLinkReceived(_ url: URL)
}
```

## Models

### NISNotificationPayload

```swift
struct NISNotificationPayload {
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
}
```

### NISDeviceInfo

```swift
struct NISDeviceInfo {
    let model: String
    let osVersion: String
    let platform: String
    let timezone: String
    let language: String
}
```

## Error Handling

### NISNotificationError

```swift
enum NISNotificationError: Error {
    case noDeviceId
    case noDeviceToken
    case registrationFailed(Error)
    case networkError(Error)
    case serverError(Int)
    case invalidResponse
}
```

## Constants

### NISLogLevel

```swift
enum NISLogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
}
```

## Network Responses

### NISDeviceRegistration

```swift
struct NISDeviceRegistration {
    let deviceId: String
    let token: String
    let defaultTopics: [String]
    let createdAt: Date
}
```

### NISTopicSubscription

```swift
struct NISTopicSubscription {
    let topic: String
    let status: String
    let subscribedAt: Date
}
```

## Extensions

### String Extensions

```swift
extension String {
    var isValidTopic: Bool
    var isValidDeviceToken: Bool
    var isValidBundleId: Bool
    var isValidAPIKey: Bool
}
```

### Dictionary Extensions

```swift
extension Dictionary {
    func jsonData() throws -> Data
    func jsonString() throws -> String?
    mutating func merge(_ other: [Key: Value])
}
```
