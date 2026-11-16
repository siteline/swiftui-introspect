#if os(iOS)
import Combine
import SwiftUI
import SwiftUIIntrospect
import XCTest

/// Measures the cost of presenting introspected views, from presentation until every introspection has customized its
/// target.
@MainActor
final class IntrospectionBenchmarks: XCTestCase {
	fileprivate static let rowCount = 100

	func testNavigationStackReceiver() throws {
		guard #available(iOS 16, *) else { throw XCTSkip("NavigationStack requires iOS 16") }
		try measurePresentation(introspections: 1) { spy in
			NavigationStack {
				Text("Root")
			}
			.introspect(.navigationStack, on: .iOS(.v16, .v17, .v18, .v26, .v27)) { _ in spy(0) }
		}
	}

	func testNavigationStackAncestor() throws {
		guard #available(iOS 16, *) else { throw XCTSkip("NavigationStack requires iOS 16") }
		try measurePresentation(introspections: 1) { spy in
			NavigationStack {
				Text("Root")
					.introspect(
						.navigationStack,
						on: .iOS(.v16, .v17, .v18, .v26, .v27),
						scope: .ancestor,
					) { _ in spy(0) }
			}
		}
	}

	func testScrollViewReceiver() throws {
		try measurePresentation(introspections: 1) { spy in
			ScrollView {
				Text("Content")
			}
			.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27)) { _ in spy(0) }
		}
	}

	func testTogglesWithoutIntrospection() throws {
		try measurePresentation(introspections: 0) { _ in
			Toggles(introspected: false, spy: { _ in })
		}
	}

	func testToggles() throws {
		try measurePresentation(introspections: Self.rowCount) { spy in
			Toggles(introspected: true, spy: spy)
		}
	}

	func testTogglesUpdate() throws {
		let model = TogglesModel()
		var customized = 0
		var target = Self.rowCount
		let completion = Completion { customized >= target }
		let window = try presentationWindow()
		window.rootViewController = UIHostingController(
			rootView: Toggles(introspected: true, model: model) { _ in
				customized += 1
				completion.update()
			},
		)
		completion.wait()

		measure(metrics: Self.metrics, options: Self.options) {
			// Toggling twice measures both directions in every iteration.
			for _ in 0..<2 {
				target = customized + Self.rowCount
				model.isOn.toggle()
				completion.wait()
			}
		}
		window.rootViewController = nil
	}

	/// Presents the view in each iteration and waits until the given number of distinct introspections customize their
	/// targets. A warm-up presentation runs first, outside of the measurements.
	private func measurePresentation(
		introspections: Int,
		@ViewBuilder _ content: @escaping (_ spy: @escaping (Int) -> Void) -> some View,
	) throws {
		let window = try presentationWindow()
		// Each presentation drains its own pool, so presentations don't accumulate across iterations.
		let present = {
			autoreleasepool {
				var introspected = Set<Int>()
				let completion = Completion { introspected.count >= introspections }
				let controller = UIHostingController(
					rootView: content {
						introspected.insert($0)
						completion.update()
					},
				)
				window.rootViewController = controller
				controller.view.layoutIfNeeded()
				completion.wait()
				window.rootViewController = nil
			}
		}
		present()
		measure(metrics: Self.metrics, options: Self.options, block: present)
	}

	private static var metrics: [XCTMetric] {
		[XCTCPUMetric(), XCTClockMetric(), XCTMemoryMetric()]
	}

	private static var options: XCTMeasureOptions {
		let options = XCTMeasureOptions()
		options.iterationCount = 10
		return options
	}

	private func presentationWindow() throws -> UIWindow {
		let window = UIApplication.shared
			.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.flatMap(\.windows)
			.first
		return try XCTUnwrap(window)
	}
}

/// Runs the main run loop until a condition holds, without polling, so waiting adds no measured work.
@MainActor
private final class Completion {
	private let isComplete: () -> Bool

	init(_ isComplete: @escaping () -> Bool) {
		self.isComplete = isComplete
	}

	/// Stops the run loop once the condition holds. Call it whenever the condition might have changed.
	func update() {
		if isComplete() {
			CFRunLoopStop(CFRunLoopGetMain())
		}
	}

	func wait(timeout: TimeInterval = 10) {
		let deadline = Date().addingTimeInterval(timeout)
		while !isComplete(), Date() < deadline {
			CFRunLoopRunInMode(.defaultMode, deadline.timeIntervalSinceNow, false)
		}
		XCTAssertTrue(isComplete(), "Introspection didn't finish within \(timeout) seconds")
	}
}

@MainActor
private final class TogglesModel: ObservableObject {
	@Published var isOn = false
}

private struct Toggles: View {
	let introspected: Bool
	@ObservedObject var model = TogglesModel()
	let spy: (Int) -> Void

	var body: some View {
		ScrollView {
			VStack {
				ForEach(0..<IntrospectionBenchmarks.rowCount, id: \.self) { index in
					if introspected {
						Toggle("Row \(index)", isOn: $model.isOn)
							.introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27)) { _ in
								spy(index)
							}
					} else {
						Toggle("Row \(index)", isOn: $model.isOn)
					}
				}
			}
		}
	}
}
#endif
