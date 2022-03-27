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
            name: "NetworkingLive",
            targets: ["NetworkingLive"]),
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
            targets: ["LoggerLive"]),
        .library(
            name: "CV-UIKit",
            targets: ["CV-UIKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.0")
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
            dependencies: [
                "Common",
                "Logger"
            ]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "Networking",
                "TestHelpers",
                .product(name: "Nimble", package: "Nimble")
            ]),
        .target(
            name: "NetworkingLive",
            dependencies: [
                "Networking"
            ]),
        .testTarget(
            name: "NetworkingLiveTests",
            dependencies: [
                "NetworkingLive",
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
            ]),
        .target(
            name: "CV-UIKit",
            dependencies: [
                "UIKitHelpers",
                "DesignSystem",
                "Logger",
                "Networking",
                "NetworkingLive",
                "Data",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]),
        .testTarget(
            name: "CV-UIKitTests",
            dependencies: [
                "CV-UIKit",
                "TestHelpers",
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "Quick", package: "Quick")
            ],
            resources: [
                .copy("Resources/empty.json"),
                .copy("Resources/whitePixel.png")
            ])
    ]
)
