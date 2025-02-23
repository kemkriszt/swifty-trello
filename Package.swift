// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyTrello",
    platforms: [.iOS(.v16), .macOS(.v13), .visionOS(.v1), .tvOS(.v16)],
    products: [.library(name: "SwiftyTrello", targets: ["SwiftyTrello"])],
    dependencies: [
        .package(url: "https://github.com/kemkriszt/SecureStore", .upToNextMajor(from: "1.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "SwiftyTrello", dependencies: [.product(name: "SecureStore", package: "SecureStore")]),
        .testTarget(
            name: "TrelloClientTests",
            dependencies: ["SwiftyTrello"]
        ),
    ]
)
