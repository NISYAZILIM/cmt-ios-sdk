# Deep Linking Guide

## Overview

NISSDK supports deep linking through push notifications, allowing you to navigate users to specific screens or content within your app.

## Deep Link Format

Deep links should follow this format:

```
yourapp://path/to/content?param1=value1&param2=value2
```

Example:

```
myapp://products/123?ref=push
```

## Configuration

1. Configure URL Schemes in Xcode:

   - Open your project settings
   - Select your target
   - Go to "Info" tab
   - Add URL scheme under "URL Types"

2. Implement Deep Link Handling:

```swift
extension AppDelegate: NISPushNotificationDelegate {
    func deepLinkReceived(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }

        // Handle different paths
        switch components.path {
        case "/products":
            handleProductDeepLink(components)
        case "/categories":
            handleCategoryDeepLink(components)
        default:
            break
        }
    }
}
```

## Push Payload Format

Include deep link in your push notification payload:

```json
{
  "aps": {
    "alert": {
      "title": "Check out this product!",
      "body": "New arrival in store"
    }
  },
  "deep_link": "myapp://products/123?ref=push"
}
```

## Examples

### Product Deep Link

```swift
func handleProductDeepLink(_ components: URLComponents) {
    guard let productId = components.queryItems?.first(where: { $0.name == "id" })?.value else {
        return
    }

    // Navigate to product detail
    navigator.navigateToProduct(productId)
}
```

### Category Deep Link

```swift
func handleCategoryDeepLink(_ components: URLComponents) {
    guard let categoryId = components.queryItems?.first(where: { $0.name == "id" })?.value else {
        return
    }

    // Navigate to category
    navigator.navigateToCategory(categoryId)
}
```

## Testing Deep Links

1. Using URL Scheme:

```bash
xcrun simctl openurl booted "myapp://products/123?ref=push"
```

2. Using Push Notification:

```swift
// Development payload
let payload = [
    "aps": [
        "alert": [
            "title": "Test Deep Link",
            "body": "Testing deep link navigation"
        ]
    ],
    "deep_link": "myapp://products/123?ref=push"
]
```

## Best Practices

1. Always validate URLs and parameters
2. Handle missing or invalid parameters gracefully
3. Implement fallback navigation
4. Consider app state when handling deep links
5. Log deep link analytics for tracking

## Troubleshooting

Common issues:

- URL scheme not registered
- Invalid URL format
- Missing URL components
- Navigation stack issues
