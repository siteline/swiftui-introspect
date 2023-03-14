// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Introspect",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
    ],
    products: [
        // legacy library
        .library(name: "Introspect", targets: ["Introspect"]),
        .library(name: "Introspect-Static", type: .static, targets: ["Introspect"]),
        .library(name: "Introspect-Dynamic", type: .dynamic, targets: ["Introspect"]),

        // new experimental library
        .library(name: "SwiftUIIntrospection", targets: ["SwiftUIIntrospection"]),
        .library(name: "SwiftUIIntrospection-Static", type: .static, targets: ["SwiftUIIntrospection"]),
        .library(name: "SwiftUIIntrospection-Dynamic", type: .dynamic, targets: ["SwiftUIIntrospection"]),
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

        .target(
            name: "SwiftUIIntrospection",
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftUIIntrospectionTests",
            dependencies: ["SwiftUIIntrospection"],
            path: "Tests"
        ),
    ]
)
