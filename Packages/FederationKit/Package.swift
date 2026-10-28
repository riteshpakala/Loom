// swift-tools-version:6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FederationKit",
    platforms: [.iOS(.v27), .macOS(.v27)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FederationKit",
            targets: ["FederationKit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // Vendored beside this package in Loom/Packages so Loom builds without remote sources
        .package(path: "../LemmyKit"),
        .package(path: "../MastodonKit"),
        .package(path: "../FeedKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FederationKit",
            dependencies: ["LemmyKit", "MastodonKit", "FeedKit"]),
        .executableTarget(name: "FederationExecutable",
                          dependencies: ["FederationKit"]),
        .testTarget(
            name: "FederationKitTests",
            dependencies: ["FederationKit"]),
    ],
    // Sources predate strict concurrency; keep Swift 5 semantics under the 6.x toolchain
    swiftLanguageModes: [.v5]
)
