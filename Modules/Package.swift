// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .macOS(.v10_15),
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
            targets: ["TestHelpers"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0")
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
            ])
    ]
)
