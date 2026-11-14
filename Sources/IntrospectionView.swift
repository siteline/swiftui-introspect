import SwiftUI

typealias IntrospectionViewID = UUID

@MainActor
private enum IntrospectionStore {
	static var anchors: [IntrospectionViewID: Weak<AnyObject>] = [:]
}

extension PlatformEntity {
	var introspectionAnchorEntity: Base? {
		if let introspectionController = self as? IntrospectionPlatformViewController {
			return IntrospectionStore.anchors[introspectionController.id]?.wrappedValue~
		}
		if let introspectionView = self as? IntrospectionPlatformView {
			return IntrospectionStore.anchors[introspectionView.id]?.wrappedValue~
		}
		if
			let view = self as? PlatformView,
			let introspectionController = view.introspectionController
		{
			return (IntrospectionStore.anchors[introspectionController.id]?.wrappedValue as? PlatformViewController)?.view~
		}
		return nil
	}
}

@MainActor
final class IntrospectionTargetCache<Target: PlatformEntity> {
	weak var target: Target? = nil

	/// Customizes the target the probe selects, and returns whether it found one.
	func select(
		from probe: any IntrospectionProbe,
		selector: (any IntrospectionProbe) -> Target?,
		customize: (Target) -> Void,
	) -> Bool {
		guard let target = selector(probe) else {
			return false
		}
		self.target = target
		customize(target)
		return true
	}

	/// Customizes the cached target, or the one the probe selects when none is cached.
	func update(
		from probe: any IntrospectionProbe,
		selector: (any IntrospectionProbe) -> Target?,
		customize: (Target) -> Void,
	) {
		guard let target = target ?? selector(probe) else {
			return
		}
		customize(target)
	}
}

/// ⚓️
struct IntrospectionAnchorView: PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias UIViewControllerType = IntrospectionAnchorPlatformViewController
	#elseif canImport(AppKit)
	typealias NSViewControllerType = IntrospectionAnchorPlatformViewController
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates

	let id: IntrospectionViewID

	init(id: IntrospectionViewID) {
		self._observed = .constant(())
		self.id = id
	}

	func makePlatformViewController(context: Context) -> IntrospectionAnchorPlatformViewController {
		IntrospectionAnchorPlatformViewController(id: id)
	}

	func updatePlatformViewController(_ controller: IntrospectionAnchorPlatformViewController, context: Context) {}

	static func dismantlePlatformViewController(
		_ controller: IntrospectionAnchorPlatformViewController,
		coordinator: Coordinator,
	) {}
}

final class IntrospectionAnchorPlatformViewController: PlatformViewController {
	init(id: IntrospectionViewID) {
		super.init(nibName: nil, bundle: nil)
		self.isIntrospectionPlatformEntity = true
		IntrospectionStore.anchors[id] = Weak(wrappedValue: self)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if canImport(UIKit)
	override func viewDidLoad() {
		super.viewDidLoad()
		view.isIntrospectionPlatformEntity = true
	}
	#elseif canImport(AppKit)
	override func loadView() {
		view = NSView()
		view.isIntrospectionPlatformEntity = true
	}
	#endif
}

struct IntrospectionView<Target: PlatformEntity>: PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias UIViewControllerType = IntrospectionPlatformViewController
	#elseif canImport(AppKit)
	typealias NSViewControllerType = IntrospectionPlatformViewController
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates
	private let id: IntrospectionViewID
	private let selector: (any IntrospectionProbe) -> Target?
	private let customize: (Target) -> Void

	init(
		id: IntrospectionViewID,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self._observed = .constant(())
		self.id = id
		self.selector = selector
		self.customize = customize
	}

	func makeCoordinator() -> IntrospectionTargetCache<Target> {
		IntrospectionTargetCache()
	}

	func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
		IntrospectionPlatformViewController(id: id) { controller in
			if context.coordinator.select(from: controller, selector: selector, customize: customize) {
				controller.handler = nil
			}
		}
	}

	func updatePlatformViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
		context.coordinator.update(from: controller, selector: selector, customize: customize)
	}

	static func dismantlePlatformViewController(
		_ controller: IntrospectionPlatformViewController,
		coordinator: Coordinator,
	) {
		controller.handler = nil
		IntrospectionStore.anchors.removeValue(forKey: controller.id)
	}
}

final class IntrospectionPlatformViewController: PlatformViewController {
	let id: IntrospectionViewID
	var handler: (() -> Void)? = nil

	fileprivate init(
		id: IntrospectionViewID,
		handler: ((IntrospectionPlatformViewController) -> Void)?,
	) {
		self.id = id
		super.init(nibName: nil, bundle: nil)
		self.handler = { [weak self] in
			guard let self else { return }
			handler?(self)
		}
		self.isIntrospectionPlatformEntity = true
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if canImport(UIKit)
	#if os(iOS)
	override var preferredStatusBarStyle: UIStatusBarStyle {
		parent?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
	}
	#endif

	override func viewDidLoad() {
		super.viewDidLoad()
		view.introspectionController = self
		view.isIntrospectionPlatformEntity = true
		handler?()
	}

	override func didMove(toParent parent: UIViewController?) {
		super.didMove(toParent: parent)
		handler?()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		handler?()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		handler?()
	}
	#elseif canImport(AppKit)
	override func loadView() {
		view = NSView()
		view.introspectionController = self
		view.isIntrospectionPlatformEntity = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		handler?()
	}

	override func viewDidAppear() {
		super.viewDidAppear()
		handler?()
	}
	#endif
}

/// ⚓️
struct IntrospectionAnchorMarkerView: PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias UIViewType = IntrospectionAnchorPlatformView
	#elseif canImport(AppKit)
	typealias NSViewType = IntrospectionAnchorPlatformView
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates

	let id: IntrospectionViewID

	init(id: IntrospectionViewID) {
		self._observed = .constant(())
		self.id = id
	}

	func makePlatformView(context: Context) -> IntrospectionAnchorPlatformView {
		IntrospectionAnchorPlatformView(id: id)
	}

	func updatePlatformView(_ view: IntrospectionAnchorPlatformView, context: Context) {}

	static func dismantlePlatformView(_ view: IntrospectionAnchorPlatformView, coordinator: Coordinator) {}
}

final class IntrospectionAnchorPlatformView: PlatformView {
	init(id: IntrospectionViewID) {
		super.init(frame: .zero)
		self.isIntrospectionPlatformEntity = true
		IntrospectionStore.anchors[id] = Weak(wrappedValue: self)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct IntrospectionMarkerView<Target: PlatformEntity>: PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias UIViewType = IntrospectionPlatformView
	#elseif canImport(AppKit)
	typealias NSViewType = IntrospectionPlatformView
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates
	private let id: IntrospectionViewID
	private let selector: (any IntrospectionProbe) -> Target?
	private let customize: (Target) -> Void

	init(
		id: IntrospectionViewID,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self._observed = .constant(())
		self.id = id
		self.selector = selector
		self.customize = customize
	}

	func makeCoordinator() -> IntrospectionTargetCache<Target> {
		IntrospectionTargetCache()
	}

	func makePlatformView(context: Context) -> IntrospectionPlatformView {
		IntrospectionPlatformView(id: id) { view in
			if context.coordinator.select(from: view, selector: selector, customize: customize) {
				view.handler = nil
			}
		}
	}

	func updatePlatformView(_ view: IntrospectionPlatformView, context: Context) {
		context.coordinator.update(from: view, selector: selector, customize: customize)
	}

	static func dismantlePlatformView(_ view: IntrospectionPlatformView, coordinator: Coordinator) {
		view.handler = nil
		IntrospectionStore.anchors.removeValue(forKey: view.id)
	}
}

final class IntrospectionPlatformView: PlatformView {
	let id: IntrospectionViewID
	var handler: (() -> Void)? = nil

	fileprivate init(
		id: IntrospectionViewID,
		handler: ((IntrospectionPlatformView) -> Void)?,
	) {
		self.id = id
		super.init(frame: .zero)
		self.handler = { [weak self] in
			guard let self else { return }
			handler?(self)
		}
		self.isIntrospectionPlatformEntity = true
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if canImport(UIKit)
	override func didMoveToWindow() {
		super.didMoveToWindow()
		handler?()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		handler?()
	}
	#elseif canImport(AppKit)
	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()
		handler?()
	}

	override func layout() {
		super.layout()
		handler?()
	}
	#endif
}

import ObjectiveC

extension PlatformView {
	fileprivate var introspectionController: IntrospectionPlatformViewController? {
		get {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			return (objc_getAssociatedObject(self, key) as? Weak<IntrospectionPlatformViewController>)?.wrappedValue
		}
		set {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			objc_setAssociatedObject(self, key, Weak(wrappedValue: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}

extension PlatformEntity {
	var isIntrospectionPlatformEntity: Bool {
		get {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			return objc_getAssociatedObject(self, key) as? Bool ?? false
		}
		set {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
