# Platform Support

Use SwiftUI Introspect on platforms that expose UIKit or AppKit backing views.

## Overview

SwiftUI Introspect supports iOS, Mac Catalyst, macOS, tvOS, and visionOS. It does not support watchOS.

If your app or package has a shared target that also builds for watchOS, exclude `SwiftUIIntrospect` from that target's watchOS dependency graph. Source-level `#if` checks are still useful, but the product should not be linked into watchOS builds.

## Swift Package Manager Targets

For a Swift package target that supports multiple Apple platforms, apply a platform condition to the dependency:

```swift
.target(
	name: "AppFeature",
	dependencies: [
		.product(
			name: "SwiftUIIntrospect",
			package: "swiftui-introspect",
			condition: .when(platforms: [.iOS, .macCatalyst, .macOS, .tvOS, .visionOS])
		),
	]
)
```

Guard imports and usage with `canImport` so the same source file can compile when the product is not present:

```swift
#if canImport(SwiftUIIntrospect)
import SwiftUIIntrospect
#endif

struct ContentView: View {
	var body: some View {
		ScrollView {
			Text("Item")
		}
		#if canImport(SwiftUIIntrospect)
		.introspect(.scrollView, on: .iOS(.v17, .v18, .v26, .v27)) { scrollView in
			scrollView.bounces = false
		}
		#endif
	}
}
```

## Xcode Multiplatform Targets

For an Xcode multiplatform target, select the `SwiftUIIntrospect` package product dependency and set its platform filter to iOS, Mac Catalyst, macOS, tvOS, and visionOS. Leave watchOS unchecked.

![An Xcode package product dependency with platform filters enabled for iOS, Mac Catalyst, macOS, tvOS, and visionOS, and disabled for watchOS.](xcode-platform-filter)

Use the same `#if canImport(SwiftUIIntrospect)` guard around imports and introspection code in shared Swift files.
