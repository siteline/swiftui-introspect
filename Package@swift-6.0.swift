// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "swiftui-introspect",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "SwiftUIIntrospect", targets: ["SwiftUIIntrospect"]),
    ],
    targets: [
        .target(
            name: "SwiftUIIntrospect",
            path: "Sources"
        ),
    ],
    swiftLanguageVersions: [.v6]
)
