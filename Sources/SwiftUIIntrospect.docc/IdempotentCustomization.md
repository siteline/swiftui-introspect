# Idempotent Customization

Write customize closures that have the same effect no matter how many times they run.

## Overview

SwiftUI Introspect calls the customize closure when it finds the target, and again every time SwiftUI updates the view that `.introspect` is attached to. During launch, animations, or frequent state changes, that can be many times per second. SwiftUI can also replace the underlying view, in which case the closure receives the new instance.

Make the closure idempotent: running it again on the same target should change nothing. Setting properties is idempotent already. Adding things isn't: subviews, constraints, gesture recognizers, and actions pile up with every call unless you check for them first, and an object created on every call replaces the previous one along with its state. Keep the closure cheap, too, because it runs on the same updates.

## Set properties

Assigning a property leaves the target in the same state however many times it runs, so the closure needs no checks:

```swift
ScrollView {
	// ...
}
.introspect(.scrollView, on: .iOS(.v17, .v18, .v26, .v27)) { scrollView in
	scrollView.bounces = false
	scrollView.keyboardDismissMode = .interactive
}
```

## Check the target before adding to it

Before adding something, check whether the target already has it. Without the check below, every update would replace the button. Check the target itself rather than a flag of your own, so that a new instance from SwiftUI gets its own:

```swift
struct SearchView: View {
	@State private var query = ""

	var body: some View {
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
```

### Properties SwiftUI manages

SwiftUI sets some properties of the views it manages, and can overwrite what the closure set right after it runs. A refresh control added the same way is an example:

```swift
struct FeedView: View {
	let model: FeedModel

	var body: some View {
		ScrollView {
			// ...
		}
		.introspect(.scrollView, on: .iOS(.v17, .v18, .v26, .v27)) { scrollView in
			guard scrollView.refreshControl == nil else { return }
			let refreshControl = UIRefreshControl()
			refreshControl.addAction(UIAction { [weak refreshControl] _ in
				Task {
					await model.reload()
					refreshControl?.endRefreshing()
				}
			}, for: .valueChanged)
			scrollView.refreshControl = refreshControl
		}
	}
}
```

On some iOS versions, SwiftUI's support for `refreshable(action:)` sets a scroll view without a refresh action back to no refresh control, after the closure's first call. Checking the target adds the control back on the next call, but if the view doesn't update again, nothing calls the closure, and the scroll view stays without one. Use SwiftUI's own API for what it manages, here `refreshable(action:)`.

## Find what you added, then update it

When a subview you add depends on SwiftUI state, add it on the first call and update it on later ones. A type of your own identifies it among the target's subviews, and constraints you activate along with the subview are added only once too:

```swift
final class NavigationBarProgressView: UIProgressView {}

struct BrowserView: View {
	let progress: Double

	var body: some View {
		NavigationStack {
			// ...
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
	}
}
```

## Replace actions instead of adding them

Some APIs replace what they're given instead of adding to it. `UIControl` keeps one action per identifier, so adding an action with a fixed identifier replaces the one from the previous call:

```swift
TextField("Amount", text: $amount)
	.introspect(.textField, on: .iOS(.v17, .v18, .v26, .v27)) { textField in
		textField.addAction(
			UIAction(identifier: UIAction.Identifier("SelectAllOnBeginEditing")) { action in
				(action.sender as? UITextField)?.selectAll(nil)
			},
			for: .editingDidBegin,
		)
	}
```

## Keep track in a state object

When the setup needs objects of its own, such as a gesture recognizer and its target, or has to be undone when the view goes away, keep it in an object the view holds in `@State`. The object lives as long as the view, so it can remember which target it set up, skip that target on later calls, and move its setup to a new instance from SwiftUI. Hold the target weakly, so the object doesn't keep it alive.

Pass SwiftUI's latest values to the object as the view updates, and capture the object rather than `self` in the closure:

```swift
extension View {
	func onTwoFingerTap(perform action: @escaping () -> Void) -> some View {
		modifier(TwoFingerTapModifier(action: action))
	}
}

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
final class TwoFingerTapRecognizer: NSObject {
	var action: () -> Void = {}
	private weak var scrollView: UIScrollView?
	private var recognizer: UITapGestureRecognizer?

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
```

SwiftUI creates the object's initial value each time it creates the view, and keeps only the first, so keep its initializer cheap. <doc:ExtendingDelegates> keeps a delegate in a state object the same way.

## Run one-time actions once per target

A state object can also tell a target's first call from later ones, for something that should happen once, like focusing a text field. Calling `becomeFirstResponder()` straight from the closure focuses the field again on every update, while remembering the field focuses it only the first time:

```swift
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
final class TextFieldFocuser {
	private weak var textField: UITextField?

	func focus(_ textField: UITextField) {
		// A field that can't become first responder yet is tried again on the next call.
		guard textField !== self.textField, textField.becomeFirstResponder() else { return }
		self.textField = textField
	}
}
```

Where SwiftUI has its own API for the action, such as `focused(_:)` for focus, prefer it.
