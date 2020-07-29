// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvancedList",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "AdvancedList",
            targets: ["AdvancedList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/crelies/ListPagination", from: "0.1.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.3.8")
    ],
    targets: [
        .target(
            name: "AdvancedList",
            dependencies: ["ListPagination"]),
        .testTarget(
            name: "AdvancedListTests",
            dependencies: ["AdvancedList", "ViewInspector"]),
    ]
)
