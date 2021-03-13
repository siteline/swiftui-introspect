// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Introspect",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11)
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
        ),
        .testTarget(
            name: "IntrospectTests",
            dependencies: ["Introspect"],
            path: "IntrospectTests"
        )
    ]
)