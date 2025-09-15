import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct NavigationViewWithColumnsStyleTests {
	#if canImport(UIKit) && (os(iOS) || os(visionOS))
	typealias PlatformNavigationViewWithColumnsStyle = UISplitViewController
	#elseif canImport(UIKit) && os(tvOS)
	typealias PlatformNavigationViewWithColumnsStyle = UINavigationController
	#elseif canImport(AppKit)
	typealias PlatformNavigationViewWithColumnsStyle = NSSplitView
	#endif

	@Test func introspect() async throws {
		try await introspection(of: PlatformNavigationViewWithColumnsStyle.self) { spy in
			NavigationView {
				ZStack {
					Color.red
					Text("Something")
				}
			}
			.navigationViewStyle(DoubleColumnNavigationViewStyle())
			#if os(iOS) || os(visionOS)
			.introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
			#elseif os(tvOS)
			.introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy)
			#elseif os(macOS)
			.introspect(.navigationView(style: .columns), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy)
			#endif
		}
	}

	@Test func introspectAsAncestor() async throws {
		try await introspection(of: PlatformNavigationViewWithColumnsStyle.self) { spy in
			NavigationView {
				ZStack {
					Color.red
					Text("Something")
						#if os(iOS) || os(visionOS)
						.introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
						#elseif os(tvOS)
						.introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy)
						#elseif os(macOS)
						.introspect(.navigationView(style: .columns), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy)
						#endif
				}
			}
			.navigationViewStyle(DoubleColumnNavigationViewStyle())
			#if os(iOS)
			// NB: this is necessary for ancestor introspection to work, because initially on iPad the "Customized" text isn't shown as it's hidden in the sidebar. This is why ancestor introspection is discouraged for most situations and it's opt-in.
			.introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
				$0.preferredDisplayMode = .oneOverSecondary
			}
			#endif
		}
	}
}
