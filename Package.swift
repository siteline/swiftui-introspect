// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Introspect",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "Introspect", targets: ["Introspect"]),
        .library(name: "Introspect-Static", type: .static, targets: ["Introspect"]),
        .library(name: "Introspect-Dynamic", type: .dynamic, targets: ["Introspect"]),
    ],
    targets: [
        .target(
            name: "Introspect",
            path: "Introspect" // TODO: rename to Sources for v1.0
        ),
        .testTarget(
            name: "IntrospectTests",
            dependencies: ["Introspect"],
            path: "IntrospectTests" // TODO: rename to Tests for v1.0
        ),
    ]
)
