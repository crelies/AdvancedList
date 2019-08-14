// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvancedList",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AdvancedList",
            targets: ["AdvancedList"]),
    ],
    targets: [
        .target(
            name: "AdvancedList",
            dependencies: []),
        .testTarget(
            name: "AdvancedListTests",
            dependencies: ["AdvancedList"]),
    ]
)
