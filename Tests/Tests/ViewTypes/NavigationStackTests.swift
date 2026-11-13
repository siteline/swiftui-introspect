#if !os(macOS)
import SwiftUI
@_spi(Advanced) @_spi(Internals) @testable import SwiftUIIntrospect
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

	#if os(iOS) && !targetEnvironment(macCatalyst)
	@available(iOS 26, *)
	@Test(arguments: [false, true])
	func `receiver stays within its stack`(combinedScope: Bool) async throws {
		let scope: IntrospectionScope = combinedScope ? [.receiver, .ancestor] : .receiver
		weak var inner: UINavigationController?
		let (outer, sibling) = try await introspection(of: UINavigationController.self) { outer, sibling in
			VStack {
				Text("Before the stacks")
				NavigationStack {
					VStack {
						Text("Outside the inner stack")
							.introspect(.navigationStack, on: .iOS(.v26...), scope: .receiver) { _ in
								Issue.record("A receiver without a stack must not select its ancestor")
							}
						NavigationStack { Text("Inner") }
							.introspect(.navigationStack, on: .iOS(.v26...), scope: .receiver) { inner = $0 }
					}
				}
				.introspect(.navigationStack, on: .iOS(.v26...), scope: scope, customize: outer)
				NavigationStack { Text("Sibling") }
					.introspect(.navigationStack, on: .iOS(.v26...), scope: scope, customize: sibling)
			}
		}
		#expect(outer !== sibling)
		// SwiftUI can collapse a nested stack. In that case receiver lookup must not return the outer one.
		let nested = controllers(in: outer).compactMap { $0 as? UINavigationController }.first { $0 !== outer }
		#expect(inner === nested)
		#expect(!controllers(in: outer).contains { $0 === sibling })
	}

	@available(iOS 26, *)
	@Test(arguments: [false, true])
	func `custom selectors opt out of view markers`(combinedScope: Bool) async throws {
		guard case let .available(_, builtIn) = iOSViewVersion<NavigationStackType, UINavigationController>.v26 else {
			Issue.record("Missing NavigationStack selector")
			return
		}
		let selector = try #require(builtIn)
		#expect(selector.viewReceiverSelector != nil)
		#expect(selector.withAncestorSelector { $0.navigationController }.viewReceiverSelector == nil)
		let expected = UINavigationController()
		var called = false
		let custom = selector
			.withReceiverSelector { _ in
				called = true
				return expected
			}
			.withAncestorSelector { _ in
				Issue.record("Combined scope must select the receiver first")
				return nil
			}
		#expect(custom.viewReceiverSelector == nil)
		let version = iOSViewVersion<NavigationStackType, UINavigationController>(for: .v26, selector: custom)
		let result = try await introspection(of: UINavigationController.self) { spy in
			NavigationStack { Text("Custom") }
				.introspect(
					.navigationStack,
					on: .iOS(version...),
					scope: combinedScope ? [.receiver, .ancestor] : .receiver,
					customize: spy,
				)
		}
		#expect(called)
		#expect(result === expected)
	}

	@available(iOS 26, *)
	@Test func `missing markers and unmatched platforms do nothing`() async {
		let store = NavigationStackIntrospectionView<UINavigationController>.Store()
		let anchor = UIView()
		let front = UIView()
		store.update(selector: { _, _ in
			Issue.record("Unattached markers must not be selected")
			return UINavigationController()
		}, customize: { _ in Issue.record("Unattached markers must not customize") })
		store.anchor = anchor
		store.front = front
		store.retry()
		await Task.yield()
		#expect(store.target == nil)
		store.dismantle(anchor)
		#expect(store.anchor == nil)
		#expect(store.customize == nil)

		let modifier = IntrospectModifier(.navigationStack, platforms: [.iOS(.v18)], scope: nil) { _ in
			Issue.record("An unmatched platform must not customize")
		}
		#expect(modifier.selector == nil)
	}

	@available(iOS 26, *)
	@Test func `search tab updates and remounts`() async throws {
		weak var original: UINavigationController?
		weak var replacement: UINavigationController?
		var updated = false
		TestUtils.present(view: SearchTabs(introspected: true) { original = $0 })
		let host = try #require(hostController() as? UIHostingController<SearchTabs>)
		try await waitUntil {
			controllers(in: host).compactMap { $0 as? UITabBarController }.first?.selectedIndex = 2
			return original != nil
		}
		host.rootView = SearchTabs(introspected: true) {
			#expect($0 === original)
			updated = true
		}
		try await waitUntil { updated }
		controllers(in: host).compactMap { $0 as? UITabBarController }.first?.selectedIndex = 0
		host.rootView = SearchTabs(introspected: true, showSearch: false) { _ in
			Issue.record("A removed search tab must not customize")
		}
		try await waitUntil { original == nil }
		host.rootView = SearchTabs(introspected: true) { replacement = $0 }
		try await waitUntil {
			controllers(in: host).compactMap { $0 as? UITabBarController }.first?.selectedIndex = 2
			return replacement != nil
		}
		#expect(original == nil)
	}

	@available(iOS 26, *)
	@Test func `search tab preserves navigation containment`() async throws {
		var structures: [String] = []
		var paths: [[String]] = []
		for introspected in [false, true] {
			var target: UINavigationController?
			TestUtils.present(view: SearchTabs(introspected: introspected) { target = $0 })
			let host = try #require(hostController())
			let deadline = Date().addingTimeInterval(3)
			var tab: UITabBarController?
			var navigation: UINavigationController?
			while Date() < deadline {
				host.view.layoutIfNeeded()
				tab = controllers(in: host).compactMap { $0 as? UITabBarController }.first
				tab?.selectedIndex = 2
				if let selected = tab?.selectedViewController {
					selected.view.layoutIfNeeded()
					navigation = controllers(in: selected).compactMap { $0 as? UINavigationController }.first
				}
				if
					navigation?.topViewController?.navigationItem.searchController != nil,
					!introspected || target != nil { break }
				await Task.yield()
			}
			let selected = try #require(tab?.selectedViewController)
			let selectedNavigation = try #require(navigation)
			#expect(selectedNavigation.topViewController?.navigationItem.searchController != nil)
			if introspected {
				#expect(target === selectedNavigation)
			}
			structures.append(structure(of: selected))
			var path: [String] = []
			var current: UIViewController? = selectedNavigation
			while let controller = current {
				path.append(structure(of: controller))
				if controller === selected { break }
				current = controller.parent
			}
			paths.append(path)
		}
		#expect(structures[0] == structures[1])
		#expect(paths[0] == paths[1])
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

	private func waitUntil(_ condition: () -> Bool, sourceLocation: SourceLocation = #_sourceLocation) async throws {
		let deadline = Date().addingTimeInterval(3)
		while !condition(), Date() < deadline {
			await Task.yield()
		}
		try #require(condition(), sourceLocation: sourceLocation)
	}

	private func structure(of controller: UIViewController) -> String {
		let kind = controller is UINavigationController ? "navigation" : "controller"
		return "\(kind)[\(controller.children.map { structure(of: $0) }.joined(separator: ","))]"
	}

	@available(iOS 26, *)
	private struct SearchTabs: View {
		let introspected: Bool
		var showSearch = true
		let customize: (UINavigationController) -> Void
		@State private var searchText = ""

		var body: some View {
			TabView {
				Tab("1", systemImage: "1.square") {
					NavigationStack {
						List { Text("1") }.navigationTitle("1")
					}
				}
				Tab("2", systemImage: "2.square") {
					NavigationStack {
						List { Text("2") }.navigationTitle("2")
					}
				}
				if showSearch {
					Tab(role: .search) {
						if introspected {
							search.introspect(.navigationStack, on: .iOS(.v26, .v27), customize: customize)
						} else {
							search
						}
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
