#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ViewControllerTests {
	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformViewController.self) { spy1, spy2, spy3 in
			TabView {
				NavigationView {
					Text("Root").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
						.introspect(
							.viewController,
							on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
							customize: spy3
						)
				}
				.navigationViewStyle(.stack)
				.tabItem {
					Image(systemName: "1.circle")
					Text("Tab 1")
				}
				.introspect(
					.viewController,
					on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
					customize: spy2
				)
			}
			.introspect(
				.viewController,
				on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
				customize: spy1
			)
		}
		#if !os(visionOS)
		#expect(entity1 is UITabBarController)
		#endif
		#expect(entity2 is UINavigationController)
		#expect(String(describing: entity3).contains("UIHostingController"))
		#expect(entity2 === entity3.parent)
	}
}
#endif
