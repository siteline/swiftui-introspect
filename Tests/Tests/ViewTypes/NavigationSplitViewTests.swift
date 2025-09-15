import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct NavigationSplitViewTests {
	#if canImport(UIKit) && (os(iOS) || os(visionOS))
	typealias PlatformNavigationSplitView = UISplitViewController
	#elseif canImport(UIKit) && os(tvOS)
	typealias PlatformNavigationSplitView = UINavigationController
	#elseif canImport(AppKit)
	typealias PlatformNavigationSplitView = NSSplitView
	#endif

	@available(iOS 16, macOS 13, *)
	@available(tvOS, introduced: 16, obsoleted: 18)
	@Test func introspect() async throws {
		try await introspection(of: PlatformNavigationSplitView.self) { spy in
			NavigationSplitView {
				ZStack {
					Color.red
					Text("Root")
				}
			} detail: {
				ZStack {
					Color.blue
					Text("Detail")
				}
			}
			#if os(iOS) || os(visionOS)
			.introspect(.navigationSplitView, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
			#elseif os(tvOS)
			.introspect(.navigationSplitView, on: .tvOS(.v16, .v17), customize: spy)
			#elseif os(macOS)
			.introspect(.navigationSplitView, on: .macOS(.v13, .v14, .v15, .v26), customize: spy)
			#endif
		}
	}

	@available(iOS 16, macOS 13, *)
	@available(tvOS, introduced: 16, obsoleted: 18)
	@Test func introspectAsAncestor() async throws {
		try await introspection(of: PlatformNavigationSplitView.self) { spy in
			// NB: columnVisibility is explicitly set here for ancestor introspection to work, because initially on iPad the sidebar is hidden, so the introspection modifier isn't triggered until the user makes the sidebar appear. This is why ancestor introspection is discouraged for most situations and it's opt-in.
			NavigationSplitView(columnVisibility: .constant(.all)) {
				ZStack {
					Color.red
					Text("Sidebar")
						#if os(iOS) || os(visionOS)
						.introspect(.navigationSplitView, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
						#elseif os(tvOS)
						.introspect(.navigationSplitView, on: .tvOS(.v16, .v17), scope: .ancestor, customize: spy)
						#elseif os(macOS)
						.introspect(.navigationSplitView, on: .macOS(.v13, .v14, .v15, .v26), scope: .ancestor, customize: spy)
						#endif
				}
			} detail: {
				ZStack {
					Color.blue
					Text("Detail")
				}
			}
		}
	}
}
