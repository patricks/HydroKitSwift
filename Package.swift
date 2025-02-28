// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "HydroKitSwift",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "HydroKitSwift",
            targets: ["HydroKitSwift"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/patricks/ZRXPSwift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "HydroKitSwift",
            dependencies: [
              .product(name: "ZRXPSwift", package: "ZRXPSwift")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
