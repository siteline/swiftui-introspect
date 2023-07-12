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
        // new module
        .library(name: "SwiftUIIntrospect", targets: ["SwiftUIIntrospect"]),
        .library(name: "SwiftUIIntrospect-Static", type: .static, targets: ["SwiftUIIntrospect"]),
        .library(name: "SwiftUIIntrospect-Dynamic", type: .dynamic, targets: ["SwiftUIIntrospect"]),

        // old module
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

        .target(
            name: "SwiftUIIntrospect",
            path: "Sources"
        ),
    ]
)
