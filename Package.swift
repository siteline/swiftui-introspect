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
        .library(name: "SwiftUIIntrospect", targets: ["SwiftUIIntrospect"]),
        .library(name: "SwiftUIIntrospect-Static", type: .static, targets: ["SwiftUIIntrospect"]),
        .library(name: "SwiftUIIntrospect-Dynamic", type: .dynamic, targets: ["SwiftUIIntrospect"]),
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
            name: "SwiftUIIntrospect",
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftUIIntrospectTests",
            dependencies: ["SwiftUIIntrospect"],
            path: "Tests"
        ),
    ]
)
