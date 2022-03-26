// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]),
        .library(
            name: "Data",
            targets: ["Data"]),
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "TestHelpers",
            targets: ["TestHelpers"]),
        .library(
            name: "UIKitHelpers",
            targets: ["UIKitHelpers"]),
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
        .library(
            name: "Logger",
            targets: ["Logger"]),
        .library(
            name: "LoggerLive",
            targets: ["LoggerLive"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "Common"
        ),
        .target(
            name: "Data"
        ),
        .target(
            name: "Networking",
            dependencies: ["Common", "Data"]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "Networking",
                "TestHelpers",
                .product(name: "Nimble", package: "Nimble")
            ]),
        .target(
            name: "TestHelpers",
            dependencies: [
                "Data",
                .product(name: "Nimble", package: "Nimble")
            ]),
        .target(
            name: "UIKitHelpers"),
        .target(
            name: "DesignSystem",
            resources: [
                .copy("Resources/Fonts/BebasNeue-Bold.ttf"),
                .copy("Resources/Fonts/BebasNeue-Regular.ttf"),
                .copy("Resources/Fonts/OpenSans-Regular.ttf")
            ]),
        .target(
            name: "Logger"),
        .testTarget(
            name: "LoggerTests",
            dependencies: [
                "Logger",
                .product(name: "Nimble", package: "Nimble")
            ]),
        .target(
            name: "LoggerLive",
            dependencies: [
                "Logger",
                .product(name: "Logging", package: "swift-log")
            ]),
        .testTarget(
            name: "LoggerLiveTests",
            dependencies: [
                "LoggerLive",
                .product(name: "Nimble", package: "Nimble")
            ])
    ]
)
