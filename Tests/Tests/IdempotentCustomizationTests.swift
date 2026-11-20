#if os(iOS)
import Combine
import SwiftUI
import SwiftUIIntrospect
import Testing

/// The examples in the Idempotent Customization article leave the same result however many times SwiftUI updates the
/// view and runs their customize closure again.
@MainActor
struct IdempotentCustomizationTests {
	@available(iOS 17, *)
	@Test func `a view checked for before adding is added once`() async throws {
		let updates = Updates()
		var textField: UITextField?
		TestUtils.present(view: UpdatingView(updates: updates) { update in
			SearchField(update: update)
				.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField = $0; updates.customized() }
		})

		try await updates.run()
		let target = try #require(textField)
		let button = try #require(target.rightView as? UIButton)
		try await updates.run()
		#expect(target.rightView === button)
		#expect(target.rightViewMode == .always)
	}

	@available(iOS 17, *)
	@Test func `a subview found by its type is added once and follows the latest state`() async throws {
		let updates = Updates()
		var navigationController: UINavigationController?
		TestUtils.present(view: UpdatingView(updates: updates) { update in
			let progress = Double(update) / Double(Updates.count)
			NavigationStack {
				Text("Page")
					.navigationTitle("Title")
			}
			.introspect(.navigationStack, on: .iOS(.v17, .v18, .v26, .v27)) { navigationController in
				let navigationBar = navigationController.navigationBar
				let progressView = navigationBar.subviews.lazy.compactMap { $0 as? NavigationBarProgressView }.first ?? {
					let progressView = NavigationBarProgressView(progressViewStyle: .bar)
					progressView.translatesAutoresizingMaskIntoConstraints = false
					navigationBar.addSubview(progressView)
					NSLayoutConstraint.activate([
						progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
						progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
						progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
					])
					return progressView
				}()
				progressView.progress = Float(progress)
			}
			.introspect(.navigationStack, on: .iOS(.v17, .v18, .v26, .v27)) { navigationController = $0; updates.customized()
			}
		})

		try await updates.run()
		let navigationBar = try #require(navigationController?.navigationBar)
		let progressViews = navigationBar.subviews.compactMap { $0 as? NavigationBarProgressView }
		#expect(progressViews.count == 1)
		let progressView = try #require(progressViews.first)
		#expect(progressView.progress == 1)

		navigationBar.layoutIfNeeded()
		let alignmentRect = progressView.alignmentRect(forFrame: progressView.frame)
		#expect(alignmentRect.width == navigationBar.bounds.width)
		#expect(abs(alignmentRect.maxY - navigationBar.bounds.maxY) < 0.01)
	}

	@available(iOS 17, *)
	@Test func `an action with a fixed identifier replaces the previous one`() async throws {
		let updates = Updates()
		var textField: UITextField?
		TestUtils.present(view: UpdatingView(updates: updates) { update in
			AmountField(update: update)
				.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField = $0; updates.customized() }
		})

		try await updates.run()
		let target = try #require(textField)
		var beginEditingActions = 0
		target.enumerateEventHandlers { _, _, event, _ in
			if event == .editingDidBegin { beginEditingActions += 1 }
		}
		#expect(beginEditingActions == 1)

		#expect(target.becomeFirstResponder())
		try await Task.sleep(nanoseconds: 300_000_000)
		let selection = try #require(target.selectedTextRange)
		#expect(target.offset(from: target.beginningOfDocument, to: selection.start) == 0)
		#expect(target.offset(from: selection.start, to: selection.end) == target.text?.count)
		target.resignFirstResponder()
	}

	@available(iOS 17, *)
	@Test func `a state object attaches its recognizer once and removes it with the view`() async throws {
		let updates = Updates()
		var scrollView: UIScrollView?
		TestUtils.present(view: UpdatingView(updates: updates) { update in
			if update < Updates.count {
				ScrollView {
					Text("Update \(update)")
				}
				.onTwoFingerTap {}
				.introspect(.scrollView, on: .iOS(.v17, .v18, .v26, .v27)) { scrollView = $0; updates.customized() }
			}
		})

		try await updates.run(count: Updates.count - 1)
		let target = try #require(scrollView)
		#expect(target.twoFingerTapRecognizers.count == 1)

		updates.current = Updates.count
		try await Task.sleep(nanoseconds: 300_000_000)
		#expect(target.twoFingerTapRecognizers.isEmpty)
	}

	@available(iOS 17, *)
	@Test func `a state object runs a one-time action once per target`() async throws {
		let updates = Updates()
		var textField: UITextField?
		TestUtils.present(view: UpdatingView(updates: updates) { update in
			NameField(update: update)
				.modifier(FocusOnAppearModifier())
				.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField = $0; updates.customized() }
		})

		try await updates.run(count: 0)
		let target = try #require(textField)
		#expect(target.isFirstResponder)

		target.resignFirstResponder()
		try await updates.run()
		#expect(!target.isFirstResponder)
	}
}

// MARK: Article examples

@available(iOS 17, *)
private struct SearchField: View {
	let update: Int
	@State private var query = ""

	var body: some View {
		let _ = update
		TextField("Search", text: $query)
			.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField in
				guard textField.rightView == nil else { return }
				textField.rightView = UIButton(primaryAction: UIAction(image: UIImage(systemName: "doc.on.clipboard")) { _ in
					query = UIPasteboard.general.string ?? ""
				})
				textField.rightViewMode = .always
			}
	}
}

private final class NavigationBarProgressView: UIProgressView {}

@available(iOS 17, *)
private struct AmountField: View {
	let update: Int
	@State private var amount = "12345"

	var body: some View {
		let _ = update
		TextField("Amount", text: $amount)
			.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField in
				textField.addAction(
					UIAction(identifier: UIAction.Identifier("SelectAllOnBeginEditing")) { action in
						(action.sender as? UITextField)?.selectAll(nil)
					},
					for: .editingDidBegin,
				)
			}
	}
}

extension View {
	@available(iOS 17, *)
	fileprivate func onTwoFingerTap(perform action: @escaping () -> Void) -> some View {
		modifier(TwoFingerTapModifier(action: action))
	}
}

@available(iOS 17, *)
private struct TwoFingerTapModifier: ViewModifier {
	let action: () -> Void
	@State private var recognizer = TwoFingerTapRecognizer()

	func body(content: Content) -> some View {
		let _ = recognizer.action = action
		content
			.introspect(.scrollView, on: .iOS(.v17, .v18, .v26, .v27)) { [recognizer] scrollView in
				recognizer.attach(to: scrollView)
			}
	}
}

@MainActor
private final class TwoFingerTapRecognizer: NSObject {
	var action: () -> Void = {}
	private weak var scrollView: UIScrollView? = nil
	private var recognizer: UITapGestureRecognizer? = nil

	func attach(to scrollView: UIScrollView) {
		guard scrollView !== self.scrollView else { return }
		detach()
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
		recognizer.numberOfTouchesRequired = 2
		scrollView.addGestureRecognizer(recognizer)
		self.scrollView = scrollView
		self.recognizer = recognizer
	}

	private func detach() {
		guard let recognizer else { return }
		scrollView?.removeGestureRecognizer(recognizer)
	}

	@objc private func tapped() {
		action()
	}

	isolated deinit {
		detach()
	}
}

@available(iOS 17, *)
private struct FocusOnAppearModifier: ViewModifier {
	@State private var focuser = TextFieldFocuser()

	func body(content: Content) -> some View {
		content
			.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { [focuser] textField in
				focuser.focus(textField)
			}
	}
}

@MainActor
private final class TextFieldFocuser {
	private weak var textField: UITextField? = nil

	func focus(_ textField: UITextField) {
		// A field that can't become first responder yet is tried again on the next call.
		guard textField !== self.textField, textField.becomeFirstResponder() else { return }
		self.textField = textField
	}
}

// MARK: Helpers

/// Drives repeated updates of an ``UpdatingView``, each of which runs its customize closures again.
@MainActor
private final class Updates: ObservableObject {
	static let count = 10

	@Published fileprivate var current = 0
	private var customizations = 0

	func customized() {
		customizations += 1
	}

	/// Waits for introspection to find its target, then updates the view `count` times, waiting for each update to
	/// customize the target again.
	func run(count: Int = Updates.count) async throws {
		await poll { self.customizations > 0 }
		for _ in 0..<count {
			let customizations = customizations
			current += 1
			await poll { self.customizations > customizations }
		}
		// The other customize closures of the last update can run after the one that reports it.
		try await Task.sleep(nanoseconds: 100_000_000)
	}
}

private struct UpdatingView<Content: View>: View {
	@ObservedObject var updates: Updates
	@ViewBuilder let content: (Int) -> Content

	var body: some View {
		content(updates.current)
	}
}

@available(iOS 17, *)
private struct NameField: View {
	let update: Int
	@State private var name = "Name"

	var body: some View {
		let _ = update
		TextField("Name", text: $name)
	}
}

extension UIScrollView {
	fileprivate var twoFingerTapRecognizers: [UITapGestureRecognizer] {
		(gestureRecognizers ?? []).compactMap { $0 as? UITapGestureRecognizer }.filter { $0.numberOfTouchesRequired == 2 }
	}
}
#endif
