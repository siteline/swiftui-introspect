// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "swiftui-introspect",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
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
    ]
)
