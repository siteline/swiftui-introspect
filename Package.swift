// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Introspect",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Introspect",
            targets: ["Introspect"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Introspect",
            dependencies: [],
            path: "Introspect"
        )
    ]
)
