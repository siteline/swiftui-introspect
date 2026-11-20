#if canImport(UIKit)
import SwiftUI
import SwiftUIIntrospect
import Testing

/// UIKit looks for the scroll view that drives a view controller's navigation bar, such as its scroll edge appearance
/// and large title, along the first subview of each view down from the view controller's view. Once introspection finds
/// its target, it leaves that path to the receiver.
@MainActor
struct ContentScrollViewTests {
	@Test func `introspected scroll view stays on the first subview path`() async throws {
		let window = try #require(
			UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first,
		)
		var introspected: UIScrollView? = nil
		let container = ContainerController(
			rootView: ScrollView {
				Text("Content")
			}
			.introspect(
				.scrollView,
				on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27),
				.tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27),
				.visionOS(.v1, .v2, .v26, .v27),
			) { introspected = $0 },
		)
		window.rootViewController = UINavigationController(rootViewController: container)

		let start = Date()
		while introspected == nil, Date().timeIntervalSince(start) < 3 {
			try await Task.sleep(nanoseconds: 10_000_000)
		}
		let scrollView = try #require(introspected)
		while !container.firstSubviewPath.contains(scrollView), Date().timeIntervalSince(start) < 4 {
			try await Task.sleep(nanoseconds: 10_000_000)
		}

		#expect(container.firstSubviewPath.contains(scrollView))
	}
}

/// A UIKit view controller that shows SwiftUI content through a child hosting controller.
private final class ContainerController<Content: View>: UIViewController {
	private let hostingController: UIHostingController<Content>

	init(rootView: Content) {
		self.hostingController = UIHostingController(rootView: rootView)
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addChild(hostingController)
		hostingController.view.frame = view.bounds
		hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(hostingController.view)
		hostingController.didMove(toParent: self)
	}

	/// The views UIKit visits looking for this view controller's content scroll view.
	var firstSubviewPath: [UIView] {
		Array(sequence(first: view, next: \.subviews.first))
	}
}
#endif
