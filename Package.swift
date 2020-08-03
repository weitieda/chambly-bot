// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chambly-bot",
    platforms: [.macOS("10.12")],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
        .package(url: "https://github.com/nmdias/FeedKit.git", from: "9.1.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "chambly-bot",
            dependencies: ["SwiftSoup", "FeedKit"]),
        .testTarget(
            name: "chambly-botTests",
            dependencies: ["chambly-bot"]),
    ]
)
