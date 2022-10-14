// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
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
            name: "TCADependencyKeys",
            targets: ["TCADependencyKeys"]),
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
            targets: ["CV-UIKit"]),
        .library(
            name: "CV-SwiftUI",
            targets: ["CV-SwiftUI"]),
        .library(
            name: "Translations",
            targets: ["Translations"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.41.0")
    ],
    targets: [
        .target(name: "Common"),
        .target(name: "Data"),
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
        .target(
            name: "TCADependencyKeys",
            dependencies: [
                "Networking",
                "NetworkingLive",
                "Logger",
                "LoggerLive",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
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
        .target(name: "UIKitHelpers"),
        .target(
            name: "DesignSystem",
            resources: [
                .copy("Resources/Fonts/BebasNeue-Bold.ttf"),
                .copy("Resources/Fonts/BebasNeue-Regular.ttf"),
                .copy("Resources/Fonts/OpenSans-Regular.ttf")
            ]),
        .target(name: "Logger"),
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
                "Translations",
                .product(name: "CombineSchedulers", package: "combine-schedulers")
            ]),
        .testTarget(
            name: "CV-UIKitTests",
            dependencies: [
                "CV-UIKit",
                "TestHelpers",
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "Quick", package: "Quick"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            exclude: [
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoading.dark.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoading.light.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoadingFailed.dark.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoadingFailed.light.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoadingSucceeded.dark.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testCollectionViewController_imageLoadingSucceeded.light.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testErrorViewController.dark.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testErrorViewController.light.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testLoadingViewController.dark.png",
                "SnapshotTesting/__Snapshots__/SnapshotTests/testLoadingViewController.light.png"
            ],
            resources: [
                .copy("Resources/empty.json"),
                .copy("Resources/whitePixel.png")
            ]),
        .target(
            name: "CV-SwiftUI",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Networking",
                "NetworkingLive",
                "TCADependencyKeys",
                "Data"
            ]),
        .testTarget(
            name: "CV-SwiftUITests",
            dependencies: [
                "CV-SwiftUI",
                "TestHelpers",
                .product(name: "Nimble", package: "Nimble"),
                .product(name: "Quick", package: "Quick")
            ]),
        .target(name: "Translations")
    ]
)
