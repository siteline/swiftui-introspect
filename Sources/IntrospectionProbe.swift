import SwiftUI

/// The kind of entities introspection inserts around the receiver to find its target: an anchor behind it, and a probe
/// in front of it.
enum IntrospectionProbeKind {
	/// Child view controllers, which find targets in both the view and view controller hierarchies. Custom selectors
	/// receive the probe itself.
	case viewController
	/// Views, which leave the view controller hierarchy untouched and find view controllers through the views they own.
	/// On UIKit, a probe that hasn't found its target retries on later frames, for about a second after it last moved
	/// or laid out.
	///
	/// Custom selectors receive the view controller enclosing the probe.
	case view
}

/// The entity introspection inserts in front of the receiver, from which selectors find their target.
@MainActor
protocol IntrospectionProbe: AnyObject {
	/// The view controller handed to custom selectors: the probe itself, or the view controller enclosing a view probe.
	var controller: PlatformViewController? { get }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry?
	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry?
}

/// Hands an introspection's anchor to its probe.
@MainActor
final class IntrospectionAnchorReference {
	fileprivate weak var controller: IntrospectionAnchorController? = nil
	fileprivate weak var view: IntrospectionAnchorView? = nil
}

extension PlatformEntity {
	var introspectionAnchorEntity: Base? {
		if let probeController = self as? IntrospectionProbeController {
			return probeController.anchorReference.controller~
		}
		if let probeView = self as? IntrospectionProbeView {
			return probeView.anchorReference.view~
		}
		if
			let view = self as? PlatformView,
			let probeController = view.introspectionProbeController
		{
			return probeController.anchorReference.controller?.view~
		}
		return nil
	}
}

/// Selects the target from a probe and hands it to `customize`, caching it once found.
@MainActor
final class IntrospectionCoordinator<Target: PlatformEntity> {
	private var selector: (any IntrospectionProbe) -> Target?
	private var customize: (Target) -> Void
	private weak var target: Target? = nil

	init(
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self.selector = selector
		self.customize = customize
	}

	/// Customizes the target the probe selects, and returns whether it found one.
	func select(from probe: any IntrospectionProbe) -> Bool {
		guard let target = selector(probe) else {
			return false
		}
		self.target = target
		customize(target)
		return true
	}

	/// Adopts the latest closures, then customizes the cached target, or the one the probe selects when none is cached.
	func update(
		from probe: any IntrospectionProbe,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self.selector = selector
		self.customize = customize
		guard let target = target ?? selector(probe) else {
			return
		}
		customize(target)
	}
}

/// ⚓️
struct IntrospectionAnchorControllerRepresentable: PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias UIViewControllerType = IntrospectionAnchorController
	#elseif canImport(AppKit)
	typealias NSViewControllerType = IntrospectionAnchorController
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates

	let anchorReference: IntrospectionAnchorReference

	init(anchorReference: IntrospectionAnchorReference) {
		self._observed = .constant(())
		self.anchorReference = anchorReference
	}

	func makePlatformViewController(context: Context) -> IntrospectionAnchorController {
		IntrospectionAnchorController(anchorReference: anchorReference)
	}

	func updatePlatformViewController(_ controller: IntrospectionAnchorController, context: Context) {}

	static func dismantlePlatformViewController(_ controller: IntrospectionAnchorController, coordinator: Coordinator) {}
}

final class IntrospectionAnchorController: PlatformViewController {
	init(anchorReference: IntrospectionAnchorReference) {
		super.init(nibName: nil, bundle: nil)
		self.isIntrospectionPlatformEntity = true
		anchorReference.controller = self
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

struct IntrospectionProbeControllerRepresentable<Target: PlatformEntity>: PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias UIViewControllerType = IntrospectionProbeController
	#elseif canImport(AppKit)
	typealias NSViewControllerType = IntrospectionProbeController
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates
	private let anchorReference: IntrospectionAnchorReference
	private let selector: (any IntrospectionProbe) -> Target?
	private let customize: (Target) -> Void

	init(
		anchorReference: IntrospectionAnchorReference,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self._observed = .constant(())
		self.anchorReference = anchorReference
		self.selector = selector
		self.customize = customize
	}

	func makeCoordinator() -> IntrospectionCoordinator<Target> {
		IntrospectionCoordinator(selector: selector, customize: customize)
	}

	func makePlatformViewController(context: Context) -> IntrospectionProbeController {
		let coordinator = context.coordinator
		return IntrospectionProbeController(anchorReference: anchorReference) { controller in
			if coordinator.select(from: controller) {
				controller.handler = nil
			}
		}
	}

	func updatePlatformViewController(_ controller: IntrospectionProbeController, context: Context) {
		context.coordinator.update(from: controller, selector: selector, customize: customize)
	}

	static func dismantlePlatformViewController(_ controller: IntrospectionProbeController, coordinator: Coordinator) {
		controller.handler = nil
	}
}

final class IntrospectionProbeController: PlatformViewController {
	let anchorReference: IntrospectionAnchorReference
	var handler: (() -> Void)? = nil

	fileprivate init(
		anchorReference: IntrospectionAnchorReference,
		handler: ((IntrospectionProbeController) -> Void)?,
	) {
		self.anchorReference = anchorReference
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
		view.introspectionProbeController = self
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
		view.introspectionProbeController = self
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

extension IntrospectionProbeController: IntrospectionProbe {
	var controller: PlatformViewController? { self }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		self.as(Entry.Base.self)?.receiver(ofType: Entry.self)
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		self.as(Entry.Base.self)?.ancestor(ofType: Entry.self)
	}
}

/// ⚓️
struct IntrospectionAnchorViewRepresentable: PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias UIViewType = IntrospectionAnchorView
	#elseif canImport(AppKit)
	typealias NSViewType = IntrospectionAnchorView
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates

	let anchorReference: IntrospectionAnchorReference

	init(anchorReference: IntrospectionAnchorReference) {
		self._observed = .constant(())
		self.anchorReference = anchorReference
	}

	func makePlatformView(context: Context) -> IntrospectionAnchorView {
		IntrospectionAnchorView(anchorReference: anchorReference)
	}

	func updatePlatformView(_ view: IntrospectionAnchorView, context: Context) {}

	static func dismantlePlatformView(_ view: IntrospectionAnchorView, coordinator: Coordinator) {}
}

final class IntrospectionAnchorView: PlatformView {
	init(anchorReference: IntrospectionAnchorReference) {
		super.init(frame: .zero)
		self.isIntrospectionPlatformEntity = true
		anchorReference.view = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

struct IntrospectionProbeViewRepresentable<Target: PlatformEntity>: PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias UIViewType = IntrospectionProbeView
	#elseif canImport(AppKit)
	typealias NSViewType = IntrospectionProbeView
	#endif

	@Binding
	private var observed: Void // workaround for state changes not triggering view updates
	private let anchorReference: IntrospectionAnchorReference
	private let selector: (any IntrospectionProbe) -> Target?
	private let customize: (Target) -> Void

	init(
		anchorReference: IntrospectionAnchorReference,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self._observed = .constant(())
		self.anchorReference = anchorReference
		self.selector = selector
		self.customize = customize
	}

	func makeCoordinator() -> IntrospectionCoordinator<Target> {
		IntrospectionCoordinator(selector: selector, customize: customize)
	}

	func makePlatformView(context: Context) -> IntrospectionProbeView {
		let coordinator = context.coordinator
		return IntrospectionProbeView(anchorReference: anchorReference) { view in
			if coordinator.select(from: view) {
				view.handler = nil
			}
		}
	}

	func updatePlatformView(_ view: IntrospectionProbeView, context: Context) {
		context.coordinator.update(from: view, selector: selector, customize: customize)
	}

	static func dismantlePlatformView(_ view: IntrospectionProbeView, coordinator: Coordinator) {
		view.handler = nil
	}
}

final class IntrospectionProbeView: PlatformView {
	let anchorReference: IntrospectionAnchorReference
	var handler: (() -> Void)? = nil

	fileprivate init(
		anchorReference: IntrospectionAnchorReference,
		handler: ((IntrospectionProbeView) -> Void)?,
	) {
		self.anchorReference = anchorReference
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
		select()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		select()
	}

	/// Looks for the target, and keeps retrying on later frames while it isn't found.
	private func select() {
		handler?()
		if handler != nil, window != nil {
			IntrospectionRetryScheduler.shared.schedule(self)
		}
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

#if canImport(UIKit)
/// Retries view probes that haven't found their target, for targets that appear without a layout pass reaching the
/// probe, such as a search bar SwiftUI adds after presentation.
///
/// After each attempt that finds nothing, a probe retries on the next frame, then after intervals that double from one
/// frame, for about a second. Finding the target, or leaving the window, ends its retries.
@MainActor
final class IntrospectionRetryScheduler: NSObject {
	static let shared = IntrospectionRetryScheduler()

	private struct Retry {
		static let limit = 7
		static let firstInterval: CFTimeInterval = 1.0 / 60

		weak var probe: IntrospectionProbeView?
		let start: CFTimeInterval
		var count = 0

		var due: CFTimeInterval {
			start + Self.firstInterval * CFTimeInterval((1 << count) - 1)
		}
	}

	private var retries: [ObjectIdentifier: Retry] = [:]

	/// Drives every probe's retries, and pauses while none are pending.
	private lazy var displayLink: CADisplayLink = {
		let displayLink = CADisplayLink(target: self, selector: #selector(retryDueProbes))
		displayLink.add(to: .main, forMode: .common)
		return displayLink
	}()

	/// Restarts the probe's retries from the next frame.
	func schedule(_ probe: IntrospectionProbeView) {
		retries[ObjectIdentifier(probe)] = Retry(probe: probe, start: CACurrentMediaTime())
		displayLink.isPaused = false
	}

	@objc private func retryDueProbes() {
		let now = CACurrentMediaTime()
		for (id, retry) in retries where retry.due <= now {
			guard let probe = retry.probe, probe.handler != nil, probe.window != nil else {
				retries[id] = nil
				continue
			}
			var next = retry
			next.count += 1
			// Set before the attempt, which can lay out the probe and so restart its retries.
			retries[id] = next.count < Retry.limit ? next : nil
			probe.handler?()
			if probe.handler == nil {
				retries[id] = nil
			}
		}
		if retries.isEmpty {
			displayLink.isPaused = true
		}
	}
}
#endif

extension IntrospectionProbeView: IntrospectionProbe {
	var controller: PlatformViewController? { enclosingController }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return receiver(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return receiverController(ofType: Entry.self)
		}
		return nil
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return ancestor(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return enclosingController.flatMap {
				sequence(first: $0, next: \.parent).firstPlatformEntity(ofType: Entry.self)
			}
		}
		return nil
	}

	/// The first view controller of the given type whose view sits between the anchor and this probe.
	private func receiverController<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		guard
			let anchor = introspectionAnchorEntity,
			let commonAncestor = anchor.nearestCommonAncestor(with: self),
			let container = commonAncestor.enclosingController
		else {
			return nil
		}
		let candidatesByView = Dictionary(
			container.allDescendants.compactMap { controller -> (ObjectIdentifier, Entry)? in
				guard
					let candidate = controller as? Entry,
					!controller.isIntrospectionPlatformEntity,
					let view = controller.loadedView
				else {
					return nil
				}
				return (ObjectIdentifier(view), candidate)
			},
			uniquingKeysWith: { first, _ in first },
		)
		guard !candidatesByView.isEmpty else {
			return nil
		}
		return commonAncestor
			.allDescendants(between: anchor, and: self)
			.lazy
			.compactMap { candidatesByView[ObjectIdentifier($0)] }
			.first
	}
}

extension PlatformViewController {
	var loadedView: PlatformView? {
		#if canImport(UIKit)
		viewIfLoaded
		#elseif canImport(AppKit)
		isViewLoaded ? view : nil
		#endif
	}
}

extension PlatformView {
	/// The innermost view controller whose view contains this view.
	///
	/// SwiftUI's hosting views take their controllers out of the responder chain, so this searches the view controller
	/// hierarchy from the window down instead.
	fileprivate var enclosingController: PlatformViewController? {
		#if canImport(UIKit)
		let roots = window?.rootViewController.map { Array(sequence(first: $0, next: \.presentedViewController)) } ?? []
		#elseif canImport(AppKit)
		let roots = window?.contentViewController.map { [$0] } ?? []
		#endif
		guard var controller = roots.last(where: isEnclosed(by:)) else {
			return nil
		}
		while let child = controller.children.first(where: isEnclosed(by:)) {
			controller = child
		}
		return controller
	}

	private func isEnclosed(by controller: PlatformViewController) -> Bool {
		controller.loadedView.map(isDescendant(of:)) ?? false
	}
}

import ObjectiveC

extension PlatformView {
	fileprivate var introspectionProbeController: IntrospectionProbeController? {
		get {
			let key = unsafeBitCast(Selector(#function), to: UnsafeRawPointer.self)
			return (objc_getAssociatedObject(self, key) as? Weak<IntrospectionProbeController>)?.wrappedValue
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
