// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "NISSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "NISSDK",
            targets: ["NISSDK"]
        ),
    ],
    dependencies: [
        // No external dependencies for core functionality
    ],
    targets: [
        .target(
            name: "NISSDK",
            dependencies: [],
            path: "Sources/NISSDK",
            exclude: ["Example", "Documentation"],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "NISSDKTests",
            dependencies: ["NISSDK"],
            path: "Tests/NISSDKTests",
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
