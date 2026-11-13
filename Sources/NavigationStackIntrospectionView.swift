#if os(iOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import UIKit

// Both probes must be views: even one controller probe changes search-tab containment.
@available(iOS 26, *)
@MainActor
struct NavigationStackIntrospectionView<Target: AnyObject>: ViewModifier {
	let selector: (UIView, UIView) -> Target?
	let customize: (Target) -> Void
	@State private var store = Store()

	func body(content: Content) -> some View {
		content
			.background(
				Marker(store: store, isAnchor: true, selector: selector, customize: customize)
					.frame(width: 0, height: 0)
					.accessibility(hidden: true),
			)
			.overlay(
				Marker(store: store, isAnchor: false, selector: selector, customize: customize)
					.frame(width: 0, height: 0)
					.accessibility(hidden: true),
			)
	}

	@MainActor
	final class Store {
		weak var anchor: UIView? = nil
		weak var front: UIView? = nil
		weak var target: Target? = nil
		var selector: ((UIView, UIView) -> Target?)? = nil
		var customize: ((Target) -> Void)? = nil
		private var pending: Task<Void, Never>? = nil

		func update(selector: @escaping (UIView, UIView) -> Target?, customize: @escaping (Target) -> Void) {
			self.selector = selector
			self.customize = customize
			if !resolve() { retry() }
		}

		private func resolve() -> Bool {
			guard let anchor, let front, anchor.window != nil, anchor.window === front.window else {
				return false
			}
			guard let target = target ?? selector?(anchor, front), let customize else {
				return false
			}
			self.target = target
			customize(target)
			return true
		}

		func retry() {
			guard anchor?.window != nil, front?.window != nil else {
				pending?.cancel()
				pending = nil
				target = nil
				return
			}
			guard target == nil, pending == nil else { return }
			// Attachment and layout provide further opportunities; never poll indefinitely.
			pending = Task { [weak self] in
				for _ in 0..<3 {
					await Task.yield()
					guard !Task.isCancelled else { return }
					if self?.resolve() == true { break }
				}
				if !Task.isCancelled { self?.pending = nil }
			}
		}

		func dismantle(_ view: UIView) {
			pending?.cancel()
			pending = nil
			if anchor === view { anchor = nil }
			if front === view { front = nil }
			target = nil
			selector = nil
			customize = nil
		}
	}

	private struct Marker: UIViewRepresentable {
		let store: Store
		let isAnchor: Bool
		let selector: (UIView, UIView) -> Target?
		let customize: (Target) -> Void
		@Binding private var observed: Void // workaround for state changes not triggering view updates

		init(
			store: Store,
			isAnchor: Bool,
			selector: @escaping (UIView, UIView) -> Target?,
			customize: @escaping (Target) -> Void,
		) {
			self.store = store
			self.isAnchor = isAnchor
			self.selector = selector
			self.customize = customize
			self._observed = .constant(())
		}

		func makeCoordinator() -> Store { store }

		func makeUIView(context: Context) -> MarkerView {
			let view = MarkerView()
			view.isIntrospectionPlatformEntity = true
			view.isUserInteractionEnabled = false
			view.accessibilityElementsHidden = true
			if isAnchor { store.anchor = view } else { store.front = view }
			view.changed = { [weak store] in store?.retry() }
			return view
		}

		func updateUIView(_ view: MarkerView, context: Context) {
			store.update(selector: selector, customize: customize)
		}

		static func dismantleUIView(_ view: MarkerView, coordinator: Store) {
			view.changed = nil
			coordinator.dismantle(view)
		}
	}

	private final class MarkerView: UIView {
		var changed: (() -> Void)? = nil

		override func didMoveToSuperview() {
			super.didMoveToSuperview()
			changed?()
		}

		override func didMoveToWindow() {
			super.didMoveToWindow()
			changed?()
		}

		override func layoutSubviews() {
			super.layoutSubviews()
			changed?()
		}
	}
}
#endif
