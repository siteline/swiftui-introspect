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
	fileprivate weak var view: IntrospectionAnchorView? = nil {
		didSet {
			if view != nil, case let .restoring(onRestore) = viewState {
				viewState = .present
				onRestore()
			}
		}
	}

	fileprivate private(set) var viewState = ViewState.present

	/// Where the anchor's view stands relative to the hierarchy.
	fileprivate enum ViewState {
		/// In the hierarchy, where the probe searches the receiver from it.
		case present
		/// Out of the hierarchy, since the probe found its target.
		case retired
		/// On its way back, to hand the probe a new anchor to search from.
		case restoring(onRestore: () -> Void)
	}

	/// Whether the probe can search from the anchor's view, or from no anchor at all for scopes that don't need one.
	fileprivate var isSearchable: Bool {
		if case .present = viewState {
			return true
		}
		return false
	}

	/// Takes the anchor's view, if there is one, out of the hierarchy once the probe found its target.
	fileprivate func retireView(rendering isAnchorRetired: Binding<Bool>) {
		guard view != nil else {
			return
		}
		viewState = .retired
		render(isRetired: true, in: isAnchorRetired)
	}

	/// Brings the retired anchor's view back, then calls `onRestore` once a new one is in place.
	fileprivate func restoreView(rendering isAnchorRetired: Binding<Bool>, onRestore: @escaping () -> Void) {
		guard case .retired = viewState else {
			return
		}
		viewState = .restoring(onRestore: onRestore)
		render(isRetired: false, in: isAnchorRetired)
	}

	private func render(isRetired: Bool, in isAnchorRetired: Binding<Bool>) {
		// on the next turn, since probes can get here during a view update
		DispatchQueue.main.async {
			isAnchorRetired.wrappedValue = isRetired
		}
	}
}

/// An entity introspection adds to the hierarchy, which selectors never return.
protocol IntrospectionPlatformEntity: AnyObject {}

extension PlatformEntity {
	var isIntrospectionPlatformEntity: Bool {
		if self is any IntrospectionPlatformEntity {
			return true
		}
		// The view of an anchor or probe view controller, which is that controller's next responder.
		guard let view = self as? PlatformView else {
			return false
		}
		#if canImport(UIKit)
		return view.next is any IntrospectionPlatformEntity
		#elseif canImport(AppKit)
		return view.nextResponder is any IntrospectionPlatformEntity
		#endif
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

	/// Adopts the latest closures, then customizes the cached target, or the one the probe selects when none is cached
	/// and a probe is given. Returns whether it found one.
	@discardableResult
	func update(
		from probe: (any IntrospectionProbe)?,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) -> Bool {
		self.selector = selector
		self.customize = customize
		guard let target = target ?? probe.flatMap(selector) else {
			return false
		}
		customize(target)
		return true
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

final class IntrospectionAnchorController: PlatformViewController, IntrospectionPlatformEntity {
	init(anchorReference: IntrospectionAnchorReference) {
		super.init(nibName: nil, bundle: nil)
		anchorReference.controller = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if !canImport(UIKit)
	override func loadView() {
		view = NSView()
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

final class IntrospectionProbeController: PlatformViewController, IntrospectionPlatformEntity {
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
		guard let anchor = anchorReference.controller else {
			return nil
		}
		if Entry.Base.self == PlatformView.self {
			return loadedView?.receiverCandidates(after: anchor.view).firstPlatformEntity(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return (self as PlatformViewController).receiverCandidates(after: anchor).firstPlatformEntity(ofType: Entry.self)
		}
		return nil
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return loadedView?.ancestors.firstPlatformEntity(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return (self as PlatformViewController).ancestors.firstPlatformEntity(ofType: Entry.self)
		}
		return nil
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

final class IntrospectionAnchorView: PlatformView, IntrospectionPlatformEntity {
	private let anchorReference: IntrospectionAnchorReference

	init(anchorReference: IntrospectionAnchorReference) {
		self.anchorReference = anchorReference
		super.init(frame: .zero)
		anchorReference.view = self
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	#if canImport(UIKit)
	override func willMove(toWindow newWindow: UIWindow?) {
		super.willMove(toWindow: newWindow)
		guard newWindow == nil, case .retired = anchorReference.viewState else {
			return
		}
		// Navigation controllers look for their content scroll view again only when they lay out, so they find the
		// receiver this anchor stood in front of.
		var controller = enclosingController
		while let current = controller {
			if current is UINavigationController {
				current.view.setNeedsLayout()
			}
			controller = current.parent
		}
	}
	#endif
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
	private let isAnchorRetired: Binding<Bool>
	private let selector: (any IntrospectionProbe) -> Target?
	private let customize: (Target) -> Void

	init(
		anchorReference: IntrospectionAnchorReference,
		isAnchorRetired: Binding<Bool>,
		selector: @escaping (any IntrospectionProbe) -> Target?,
		customize: @escaping (Target) -> Void,
	) {
		self._observed = .constant(())
		self.anchorReference = anchorReference
		self.isAnchorRetired = isAnchorRetired
		self.selector = selector
		self.customize = customize
	}

	func makeCoordinator() -> IntrospectionCoordinator<Target> {
		IntrospectionCoordinator(selector: selector, customize: customize)
	}

	func makePlatformView(context: Context) -> IntrospectionProbeView {
		let coordinator = context.coordinator
		let anchorReference = anchorReference
		let isAnchorRetired = isAnchorRetired
		return IntrospectionProbeView(anchorReference: anchorReference) { view in
			guard coordinator.select(from: view) else {
				return
			}
			view.handler = nil
			anchorReference.retireView(rendering: isAnchorRetired)
		}
	}

	func updatePlatformView(_ view: IntrospectionProbeView, context: Context) {
		// Without its anchor, the probe can't tell the receiver apart, so it only customizes the cached target.
		let found = context.coordinator.update(
			from: anchorReference.isSearchable ? view : nil,
			selector: selector,
			customize: customize,
		)
		if !found {
			anchorReference.restoreView(rendering: isAnchorRetired) { [weak view] in
				view?.rearm()
			}
		}
	}

	static func dismantlePlatformView(_ view: IntrospectionProbeView, coordinator: Coordinator) {
		view.handler = nil
	}
}

final class IntrospectionProbeView: PlatformView, IntrospectionPlatformEntity {
	let anchorReference: IntrospectionAnchorReference
	var handler: (() -> Void)? = nil
	private let attempt: (IntrospectionProbeView) -> Void

	fileprivate init(
		anchorReference: IntrospectionAnchorReference,
		attempt: @escaping (IntrospectionProbeView) -> Void,
	) {
		self.anchorReference = anchorReference
		self.attempt = attempt
		super.init(frame: .zero)
		rearm()
	}

	/// Looks for the target again, from the probe's next layout on. View probes search again once their anchor comes
	/// back, which view controller probes never retire.
	func rearm() {
		handler = { [weak self] in
			guard let self else { return }
			attempt(self)
		}
		#if canImport(UIKit)
		setNeedsLayout()
		#elseif canImport(AppKit)
		needsLayout = true
		#endif
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
		guard let anchor = anchorReference.view else {
			return nil
		}
		if Entry.Base.self == PlatformView.self {
			return (self as PlatformView).receiverCandidates(after: anchor).firstPlatformEntity(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return firstReceiverController(after: anchor, where: { $0 is Entry }) as? Entry
		}
		return nil
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return (self as PlatformView).ancestors.firstPlatformEntity(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return enclosingController.flatMap {
				sequence(first: $0, next: \.parent).firstPlatformEntity(ofType: Entry.self)
			}
		}
		return nil
	}

	/// The first view controller that matches and whose view sits between the anchor and this probe, in the view
	/// controller hierarchy's order, as the view controller probe finds it.
	private func firstReceiverController(
		after anchor: PlatformView,
		where matches: (PlatformViewController) -> Bool,
	) -> PlatformViewController? {
		guard let container = anchor.nearestCommonAncestor(with: self)?.enclosingController else {
			return nil
		}
		return container.allDescendants.first { controller in
			guard
				matches(controller),
				!controller.isIntrospectionPlatformEntity,
				let view = controller.loadedView
			else {
				return false
			}
			return anchor.precedes(view) && view.precedes(self)
		}
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

	/// Whether this view comes before the other in a depth-first traversal of the view hierarchy, which visits views
	/// before their subviews.
	fileprivate func precedes(_ other: PlatformView) -> Bool {
		let otherAncestors = Array(sequence(first: other, next: \.superview))
		let depths = Dictionary(
			otherAncestors.enumerated().map { (ObjectIdentifier($1), $0) },
			uniquingKeysWith: { first, _ in first },
		)
		var child: PlatformView? = nil
		for view in sequence(first: self, next: \.superview) {
			if let depth = depths[ObjectIdentifier(view)] {
				guard let child else {
					// This view is the other's ancestor, or the other itself.
					return depth > 0
				}
				guard depth > 0 else {
					// The other is this view's ancestor.
					return false
				}
				let otherChild = otherAncestors[depth - 1]
				guard
					let index = view.subviews.firstIndex(where: { $0 === child }),
					let otherIndex = view.subviews.firstIndex(where: { $0 === otherChild })
				else {
					return false
				}
				return index < otherIndex
			}
			child = view
		}
		return false
	}
}
