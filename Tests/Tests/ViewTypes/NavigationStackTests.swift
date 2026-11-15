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

	@available(iOS 16, tvOS 16, *)
	@Test func `introspect as ancestor from a pushed view`() async throws {
		try await introspection(of: PlatformNavigationStack.self) { spy in
			NavigationStack(path: .constant([1])) {
				Text("Root")
					.navigationDestination(for: Int.self) { _ in
						Text("Pushed")
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

	@available(iOS 16, tvOS 16, *)
	@Test func `introspect as ancestor from a sheet`() async throws {
		let (outer, presented) = try await introspection(of: PlatformNavigationStack.self) { outer, presented in
			NavigationStack {
				Text("Root")
					.sheet(isPresented: .constant(true)) {
						NavigationStack {
							Text("Sheet")
								.introspect(
									.navigationStack,
									on: .iOS(.v16, .v17, .v18, .v26, .v27),
									.tvOS(.v16, .v17, .v18, .v26, .v27),
									.visionOS(.v1, .v2, .v26, .v27),
									scope: .ancestor,
									customize: presented,
								)
						}
					}
			}
			.introspect(
				.navigationStack,
				on: .iOS(.v16, .v17, .v18, .v26, .v27),
				.tvOS(.v16, .v17, .v18, .v26, .v27),
				.visionOS(.v1, .v2, .v26, .v27),
				customize: outer,
			)
		}
		#expect(outer !== presented)
		#expect(outer.presentedViewController != nil)
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
							.introspect(.navigationStack, on: .iOS(.v16, .v17, .v18, .v26, .v27), scope: .receiver) { _ in
								Issue.record("A receiver without a stack must not select its ancestor")
							}
						NavigationStack { Text("Inner") }
							.introspect(.navigationStack, on: .iOS(.v16, .v17, .v18, .v26, .v27), scope: .receiver) {
								inner = $0
							}
					}
				}
				.introspect(.navigationStack, on: .iOS(.v16, .v17, .v18, .v26, .v27), scope: scope, customize: outer)
				NavigationStack { Text("Sibling") }
					.introspect(.navigationStack, on: .iOS(.v16, .v17, .v18, .v26, .v27), scope: scope, customize: sibling)
			}
		}
		#expect(outer !== sibling)
		// SwiftUI can collapse a nested stack. In that case receiver lookup must not return the outer one.
		let nested = controllers(in: outer).compactMap { $0 as? UINavigationController }.first { $0 !== outer }
		#expect(inner === nested)
		#expect(!controllers(in: outer).contains { $0 === sibling })
	}

	/// Reselecting a tab pops its stack to the root view. The test reselects it by sending the tab button's action, and
	/// also runs without introspection to show that this reselects the tab.
	@available(iOS 18, *)
	@Test(arguments: [nil, .receiver, [.receiver, .ancestor]] as [IntrospectionScope?])
	func `reselecting a tab pops its stack to root`(scope: IntrospectionScope?) async throws {
		TestUtils.present(view: ReselectTabs(scope: scope))
		let navigationController = try await waitForValue {
			hostController()
				.flatMap { controllers(in: $0).lazy.compactMap { $0 as? UINavigationController }.first }
				.flatMap { $0.viewControllers.count == 2 ? $0 : nil }
		}
		let tabButton = try await waitForValue {
			hostController()
				.flatMap { controllers(in: $0).lazy.compactMap { $0 as? UITabBarController }.first }
				.flatMap { views(in: $0.tabBar).lazy.compactMap { $0 as? UIControl }.first { $0.isSelected } }
		}
		tabButton.sendActions(for: .touchUpInside)
		_ = try await waitForValue { navigationController.viewControllers.count == 1 ? () : nil }
	}

	@available(iOS 18, *)
	private struct ReselectTabs: View {
		let scope: IntrospectionScope?
		@State private var path = [1]

		var body: some View {
			TabView {
				Tab("1", systemImage: "1.square") {
					if let scope {
						stack.introspect(.navigationStack, on: .iOS(.v18, .v26, .v27), scope: scope) { _ in }
					} else {
						stack
					}
				}
				Tab("2", systemImage: "2.square") {
					Text("2")
				}
			}
		}

		private var stack: some View {
			NavigationStack(path: $path) {
				Text("Root")
					.navigationDestination(for: Int.self) { Text("Pushed \($0)") }
			}
		}
	}
	#endif

	@available(iOS 18, tvOS 18, visionOS 2, *)
	@Test(arguments: [IntrospectionScope.receiver, [.receiver, .ancestor]])
	func `introspection leaves search tab containment intact`(scope: IntrospectionScope) async throws {
		let (expected, _) = try await searchTab(introspecting: nil)
		let (actual, introspected) = try await searchTab(introspecting: scope)
		#expect(actual == expected)
		let navigationController = try #require(introspected)
		#if !os(tvOS)
		#expect(navigationController.topViewController?.navigationItem.searchController != nil)
		#endif
	}

	/// Selects the search tab, and returns its view controller hierarchy along with the introspected navigation
	/// controller.
	@available(iOS 18, tvOS 18, visionOS 2, *)
	private func searchTab(
		introspecting scope: IntrospectionScope?,
	) async throws -> (structure: String, navigationController: UINavigationController?) {
		var navigationController: UINavigationController?
		TestUtils.present(view: SearchTabs(scope: scope) { navigationController = $0 })
		let selected = try await waitForValue { () -> UIViewController? in
			let tabBarController = hostController().flatMap {
				controllers(in: $0).lazy.compactMap { $0 as? UITabBarController }.first
			}
			tabBarController?.selectedIndex = 2
			guard
				let selected = tabBarController?.selectedViewController,
				controllers(in: selected).contains(where: { $0 is UINavigationController }),
				scope == nil || navigationController != nil
			else {
				return nil
			}
			return selected
		}
		return (structure(of: selected), navigationController)
	}

	@available(iOS 18, tvOS 18, visionOS 2, *)
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
						search.introspect(
							.navigationStack,
							on: .iOS(.v18, .v26, .v27),
							.tvOS(.v18, .v26, .v27),
							.visionOS(.v2, .v26, .v27),
							scope: scope,
							customize: customize,
						)
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

	private func waitForValue<Value>(
		sourceLocation: SourceLocation = #_sourceLocation,
		_ value: () -> Value?,
	) async throws -> Value {
		let deadline = Date().addingTimeInterval(3)
		while Date() < deadline {
			if let value = value() {
				return value
			}
			await Task.yield()
		}
		return try #require(value(), sourceLocation: sourceLocation)
	}

	private func controllers(in controller: UIViewController) -> [UIViewController] {
		[controller] + controller.children.flatMap { controllers(in: $0) }
	}

	private func views(in view: UIView) -> [UIView] {
		[view] + view.subviews.flatMap { views(in: $0) }
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
}
#endif
