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
				on: .iOS(.v16, .v17, .v18, .v26, .v27),
				.tvOS(.v16, .v17, .v18, .v26, .v27),
				.visionOS(.v1, .v2, .v26, .v27),
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
							on: .iOS(.v16, .v17, .v18, .v26, .v27),
							.tvOS(.v16, .v17, .v18, .v26, .v27),
							.visionOS(.v1, .v2, .v26, .v27),
							scope: .ancestor,
							customize: spy,
						)
				}
			}
		}
	}

	#if os(iOS)
	@available(iOS 16, *)
	@Test(arguments: [IntrospectionScope.receiver, [.receiver, .ancestor]])
	func `receiver stays within its stack`(scope: IntrospectionScope) async throws {
		weak var inner: UINavigationController?
		let (outer, sibling) = try await introspection(of: UINavigationController.self) { outer, sibling in
			VStack {
				NavigationStack {
					VStack {
						Text("Outside the inner stack")
							.introspect(.navigationStack, on: .iOS(.v16...), scope: .receiver) { _ in
								Issue.record("A receiver without a stack must not select its ancestor")
							}
						NavigationStack { Text("Inner") }
							.introspect(.navigationStack, on: .iOS(.v16...), scope: .receiver) { inner = $0 }
					}
				}
				.introspect(.navigationStack, on: .iOS(.v16...), scope: scope, customize: outer)
				NavigationStack { Text("Sibling") }
					.introspect(.navigationStack, on: .iOS(.v16...), scope: scope, customize: sibling)
			}
		}
		#expect(outer !== sibling)
		// SwiftUI can collapse a nested stack. In that case receiver lookup must not return the outer one.
		let nested = controllers(in: outer).compactMap { $0 as? UINavigationController }.first { $0 !== outer }
		#expect(inner === nested)
		#expect(!controllers(in: outer).contains { $0 === sibling })
	}

	@available(iOS 18, *)
	@Test(arguments: [IntrospectionScope.receiver, [.receiver, .ancestor]])
	func `introspection leaves search tab containment intact`(scope: IntrospectionScope) async throws {
		let (expected, _) = try await searchTab(introspecting: nil)
		let (actual, navigationController) = try await searchTab(introspecting: scope)
		#expect(actual == expected)
		#expect(navigationController?.topViewController?.navigationItem.searchController != nil)
	}

	/// Selects the search tab, and returns its view controller hierarchy along with the introspected navigation
	/// controller.
	@available(iOS 18, *)
	private func searchTab(
		introspecting scope: IntrospectionScope?,
	) async throws -> (structure: String, navigationController: UINavigationController?) {
		var navigationController: UINavigationController?
		TestUtils.present(view: SearchTabs(scope: scope) { navigationController = $0 })
		let deadline = Date().addingTimeInterval(3)
		var selected: UIViewController?
		while Date() < deadline {
			let tabBarController = hostController().flatMap {
				controllers(in: $0).lazy.compactMap { $0 as? UITabBarController }.first
			}
			tabBarController?.selectedIndex = 2
			selected = tabBarController?.selectedViewController
			let isLoaded = selected.map { controllers(in: $0).contains { $0 is UINavigationController } } ?? false
			if isLoaded, scope == nil || navigationController != nil {
				break
			}
			await Task.yield()
		}
		return try (structure(of: #require(selected)), navigationController)
	}

	private func controllers(in controller: UIViewController) -> [UIViewController] {
		[controller] + controller.children.flatMap { controllers(in: $0) }
	}

	private func hostController() -> UIViewController? {
		UIApplication.shared
			.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.flatMap(\.windows)
			.first(where: { $0.isKeyWindow })?
			.rootViewController
	}

	private func structure(of controller: UIViewController) -> String {
		let kind = controller is UINavigationController ? "navigation" : "controller"
		return "\(kind)[\(controller.children.map { structure(of: $0) }.joined(separator: ","))]"
	}

	@available(iOS 18, *)
	private struct SearchTabs: View {
		let scope: IntrospectionScope?
		let customize: (UINavigationController) -> Void
		@State private var searchText = ""

		var body: some View {
			TabView {
				Tab("1", systemImage: "1.square") {
					NavigationStack { Text("1") }
				}
				Tab("2", systemImage: "2.square") {
					NavigationStack { Text("2") }
				}
				Tab(role: .search) {
					if let scope {
						search.introspect(.navigationStack, on: .iOS(.v18, .v26, .v27), scope: scope, customize: customize)
					} else {
						search
					}
				}
			}
		}

		private var search: some View {
			NavigationStack {
				List { Text("Search") }
					.navigationTitle("Search")
					.searchable(text: $searchText)
			}
		}
	}
	#endif
}
#endif
