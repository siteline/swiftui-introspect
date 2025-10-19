// swift-tools-version:6.0

import PackageDescription

let package = Package(
	name: "swiftui-introspect",
	platforms: [
		.iOS(.v13),
		.macCatalyst(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.visionOS(.v1),
	],
	products: [
		.library(name: "SwiftUIIntrospect", targets: ["SwiftUIIntrospect"]),
		.library(name: "SwiftUIIntrospect-Static", type: .static, targets: ["SwiftUIIntrospect"]),
		.library(name: "SwiftUIIntrospect-Dynamic", type: .dynamic, targets: ["SwiftUIIntrospect"]),
	],
	targets: [
		.target(
			name: "SwiftUIIntrospect",
			path: "Sources"
		),
	]
)

for target in package.targets {
	target.swiftSettings = target.swiftSettings ?? []
	target.swiftSettings? += [
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault"),
	]
}
