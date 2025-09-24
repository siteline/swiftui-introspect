#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct NavigationViewWithStackStyleTests {
	typealias PlatformNavigationViewWithStackStyle = UINavigationController

	@Test func introspect() async throws {
		try await introspection(of: PlatformNavigationViewWithStackStyle.self) { spy in
			NavigationView {
				ZStack {
					Color.red
					Text("Something")
				}
			}
			.navigationViewStyle(.stack)
			.introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
		}
	}

	@Test func introspectAsAncestor() async throws {
		try await introspection(of: PlatformNavigationViewWithStackStyle.self) { spy in
			NavigationView {
				ZStack {
					Color.red
					Text("Something")
						.introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
				}
			}
			.navigationViewStyle(.stack)
		}
	}
}
#endif
