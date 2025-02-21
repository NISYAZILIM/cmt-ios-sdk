# NISSDK Configuration Guide

## Basic Configuration

The SDK can be configured during initialization:

```swift
let config = NISConfiguration(
    environment: .development,
    logLevel: .debug,
    autoRegisterDefaultTopics: true
)

NISNotificationClient.initialize(apiKey: "your-api-key")
```

## Environment Configuration

### Available Environments

```swift
// Development
.development

// Staging
.staging

// Production
.production

// Custom
.custom(NISEnvironmentConfiguration(
    baseURL: URL(string: "https://your-api.com")!,
    apiVersion: "v2",
    additionalHeaders: ["Custom-Header": "Value"],
    useSSLPinning: true
))
```

## Logging Configuration

### Log Levels

```swift
public enum NISLogLevel {
    case debug    // Detailed information for debugging
    case info     // General information
    case warning  // Warnings that should be investigated
    case error    // Errors that need immediate attention
}
```

### Enable Logging

```swift
NISConfiguration(logLevel: .debug)
```

## Cache Configuration

```swift
let cacheConfig = NISCacheConfiguration(
    maxAge: 3600,        // Cache lifetime in seconds
    persistBetweenLaunches: true,
    maxSize: 10_000_000  // 10MB in bytes
)
```

## Network Configuration

```swift
let config = NISConfiguration(
    maxRetryAttempts: 3,
    timeoutInterval: 30.0
)
```

## Topic Management

### Auto-subscribe Configuration

```swift
NISConfiguration(
    autoRegisterDefaultTopics: true  // Will subscribe to default topics on registration
)
```

## Security Configuration

### SSL Pinning

```swift
let customConfig = NISEnvironmentConfiguration(
    baseURL: URL(string: "https://api.example.com")!,
    useSSLPinning: true
)

let config = NISConfiguration(
    environment: .custom(customConfig)
)
```

## Complete Configuration Example

```swift
let environmentConfig = NISEnvironmentConfiguration(
    baseURL: URL(string: "https://api.example.com")!,
    apiVersion: "v2",
    additionalHeaders: [
        "Custom-Header": "Value"
    ],
    useSSLPinning: true
)

let cacheConfig = NISCacheConfiguration(
    maxAge: 3600,
    persistBetweenLaunches: true,
    maxSize: 10_000_000
)

let config = NISConfiguration(
    environment: .custom(environmentConfig),
    logLevel: .debug,
    autoRegisterDefaultTopics: true,
    maxRetryAttempts: 3,
    timeoutInterval: 30.0,
    automaticTokenRefresh: true,
    cacheConfig: cacheConfig
)

NISNotificationClient.initialize(apiKey: "your-api-key")
```
