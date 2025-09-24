internal import SwiftUI
internal import SwiftUIIntrospect

struct TestView: View {
	var body: some View {
		Text("Hello, World!")
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: { _ in })
			#elseif os(macOS)
			.introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: { _ in })
			#endif
	}
}
