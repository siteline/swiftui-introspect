// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Introspect",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "Introspect", targets: ["Introspect"]),
        .library(name: "Introspect-Static", type: .static, targets: ["Introspect"]),
        .library(name: "Introspect-Dynamic", type: .dynamic, targets: ["Introspect"]),
    ],
    targets: [
        .target(
            name: "Introspect",
            path: "Introspect"
        ),
        .testTarget(
            name: "IntrospectTests",
            dependencies: ["Introspect"],
            path: "IntrospectTests"
        ),
    ]
)
