// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit", dependencies: []),
        .executableTarget(name: "FeedExecutable",
                          dependencies: ["FeedKit"]),
        .testTarget(name: "Tests", dependencies: ["FeedKit"], path: "Tests")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
