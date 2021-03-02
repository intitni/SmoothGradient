// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SmoothGradient",
    products: [
        .library(
            name: "SmoothGradient",
            targets: ["SmoothGradient"]),
    ],
    targets: [
        .target(
            name: "SmoothGradient",
            dependencies: []),
        .testTarget(
            name: "SmoothGradientTests",
            dependencies: ["SmoothGradient"]),
    ]
)
