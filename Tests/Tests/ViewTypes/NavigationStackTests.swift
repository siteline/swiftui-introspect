#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
struct NavigationStackTests {
	typealias PlatformNavigationStack = UINavigationController

	@available(iOS 16, tvOS 16, *)
	@Test func introspect() async throws {
		try await introspection(of: PlatformNavigationStack.self) { spy in
			NavigationStack {
				ZStack {
					Color.red
					Text("Something")
				}
			}
			.introspect(
				.navigationStack,
				on: .iOS(.v16, .v17, .v18),
				.tvOS(.v16, .v17, .v18),
				.visionOS(.v1, .v2),
				customize: spy,
			)
		}
	}

	@available(iOS 16, tvOS 16, *)
	@Test func `introspect as ancestor`() async throws {
		try await introspection(of: PlatformNavigationStack.self) { spy in
			NavigationStack {
				ZStack {
					Color.red
					Text("Something")
						.introspect(
							.navigationStack,
							on: .iOS(.v16, .v17, .v18),
							.tvOS(.v16, .v17, .v18),
							.visionOS(.v1, .v2),
							scope: .ancestor,
							customize: spy,
						)
				}
			}
		}
	}
}
#endif
