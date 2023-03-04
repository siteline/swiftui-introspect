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
        .library(name: "Introspect", targets: ["Introspect"]),
        .library(name: "Introspect-Static", type: .static, targets: ["Introspect"]),
        .library(name: "Introspect-Dynamic", type: .dynamic, targets: ["Introspect"]),

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
        .target(
            name: "SwiftUIIntrospectionTests",
            dependencies: ["SwiftUIIntrospection"],
            path: "Tests"
        ),
    ]
)
