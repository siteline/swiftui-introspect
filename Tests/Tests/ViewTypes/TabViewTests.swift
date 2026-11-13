#if !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TabViewTests {
	#if canImport(UIKit)
	typealias PlatformTabView = UITabBarController
	#elseif canImport(AppKit)
	typealias PlatformTabView = NSTabView
	#endif

	@Test(.obsoleted(macOS: 15))
	func introspect() async throws {
		try await introspection(of: PlatformTabView.self) { spy in
			TabView {
				ZStack {
					Color.red
					Text("Something")
				}
			}
			#if os(iOS) || os(tvOS)
			.introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy)
			#elseif os(macOS)
			.introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), customize: spy)
			#endif
		}
	}

	@Test(.obsoleted(macOS: 15))
	func introspectAsAncestor() async throws {
		try await introspection(of: PlatformTabView.self) { spy in
			TabView {
				ZStack {
					Color.red
					Text("Something")
						#if os(iOS) || os(tvOS)
						.introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy)
						#elseif os(macOS)
						.introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), scope: .ancestor, customize: spy)
						#endif
				}
			}
		}
	}

	@available(tvOS, unavailable)
	@Test func introspectWithNonRootPlacement() async throws {
		try await introspection(of: PlatformTabView.self) { spy in
			GroupBox {
				TabView {
					ZStack {
						Color.red
						Text("Something")
					}
				}
				#if os(iOS) || os(tvOS)
				.introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy)
				#elseif os(macOS)
				.introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy)
				#endif
			}
		}
	}

	@available(tvOS, unavailable)
	@Test func introspectWithNonRootPlacementAsAncestor() async throws {
		try await introspection(of: PlatformTabView.self) { spy in
			GroupBox {
				TabView {
					ZStack {
						Color.red
						Text("Something")
							#if os(iOS) || os(tvOS)
							.introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy)
							#elseif os(macOS)
							.introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy)
							#endif
					}
				}
			}
		}
	}
}
#endif
