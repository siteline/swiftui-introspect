#if os(iOS) && !targetEnvironment(macCatalyst)
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import Testing

/// Introspection keeps the status bar style of the view controller it introspects in, both before a push and after
/// popping back to it.
///
/// The scene's status bar manager reports the style these tests check from iOS 16 on. On iOS 15 it reports
/// `.darkContent` throughout, with either probe.
@MainActor
struct StatusBarStyleTests {
	@available(iOS 16, *)
	@Test func `view probe`() async throws {
		try await expectStatusBarStyle { spy in
			Text("Root")
				.introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { _ in spy() }
		}
	}

	@available(iOS 16, *)
	@Test func `view controller probe`() async throws {
		try await expectStatusBarStyle { spy in
			Text("Root")
				.introspect(.parentController, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { _ in spy() }
		}
	}

	private func expectStatusBarStyle(
		@ViewBuilder _ root: (_ spy: @escaping () -> Void) -> some View,
	) async throws {
		let window = try #require(
			UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first,
		)
		var introspected = false
		let navigationController = UINavigationController(
			rootViewController: LightStatusBarHostingController(rootView: root { introspected = true }),
		)
		// A navigation controller only defers its status bar style to its top view controller while its bar is hidden.
		navigationController.isNavigationBarHidden = true
		window.rootViewController = navigationController
		let start = Date()
		while !introspected, Date().timeIntervalSince(start) < 3 {
			await Task.yield()
		}
		try #require(introspected)
		try await Task.sleep(nanoseconds: 300_000_000)
		#expect(window.windowScene?.statusBarManager?.statusBarStyle == .lightContent)

		navigationController.pushViewController(UIHostingController(rootView: Text("Pushed")), animated: false)
		try await Task.sleep(nanoseconds: 300_000_000)
		navigationController.popViewController(animated: false)
		try await Task.sleep(nanoseconds: 300_000_000)

		#expect(window.windowScene?.statusBarManager?.statusBarStyle == .lightContent)
	}
}

private final class LightStatusBarHostingController<Content: View>: UIHostingController<Content> {
	override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
}

/// Introspects the view controller that contains the receiver with a custom selector, which uses a view controller
/// probe.
private struct ParentControllerType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ParentControllerType {
	fileprivate static var parentController: Self { .init() }
}

extension iOSViewVersion<ParentControllerType, UIViewController> {
	fileprivate static let v13 = Self(for: .v13, selector: selector)
	fileprivate static let v14 = Self(for: .v14, selector: selector)
	fileprivate static let v15 = Self(for: .v15, selector: selector)
	fileprivate static let v16 = Self(for: .v16, selector: selector)
	fileprivate static let v17 = Self(for: .v17, selector: selector)
	fileprivate static let v18 = Self(for: .v18, selector: selector)

	private static var selector: IntrospectionSelector<UIViewController> {
		.default.withReceiverSelector { $0.parent }
	}
}
#endif
