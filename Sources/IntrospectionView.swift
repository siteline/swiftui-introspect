import SwiftUI

typealias IntrospectionAnchorID = UUID

/// ⚓️
struct IntrospectionAnchorView: PlatformViewControllerRepresentable {
    #if canImport(UIKit)
    typealias UIViewControllerType = IntrospectionAnchorPlatformViewController
    #elseif canImport(AppKit)
    typealias NSViewControllerType = IntrospectionAnchorPlatformViewController
    #endif

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates

    let id: IntrospectionAnchorID

    init(id: IntrospectionAnchorID) {
        self._observed = .constant(())
        self.id = id
    }

    func makePlatformViewController(context: Context) -> IntrospectionAnchorPlatformViewController {
        IntrospectionAnchorPlatformViewController(id: id)
    }

    func updatePlatformViewController(_ controller: IntrospectionAnchorPlatformViewController, context: Context) {}

    static func dismantlePlatformViewController(_ controller: IntrospectionAnchorPlatformViewController, coordinator: Coordinator) {}
}

final class IntrospectionAnchorPlatformViewController: PlatformViewController {
    let id: IntrospectionAnchorID

    init(id: IntrospectionAnchorID) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if canImport(UIKit)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tag = id.hashValue
    }
    #elseif canImport(AppKit)
    final class TaggableView: NSView {
        private var _tag: Int?
        override var tag: Int {
            get { _tag ?? super.tag }
            set { _tag = newValue }
        }
    }

    override func loadView() {
        let view = TaggableView()
        view.tag = id.hashValue
        self.view = view
    }
    #endif
}

struct IntrospectionView<Target: PlatformEntity>: PlatformViewControllerRepresentable {
    #if canImport(UIKit)
    typealias UIViewControllerType = IntrospectionPlatformViewController
    #elseif canImport(AppKit)
    typealias NSViewControllerType = IntrospectionPlatformViewController
    #endif

    final class TargetCache {
        weak var target: Target?
    }

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates
    private let selector: (IntrospectionPlatformViewController) -> Target?
    private let customize: (Target) -> Void

    init(
        selector: @escaping (IntrospectionPlatformViewController) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self._observed = .constant(())
        self.selector = selector
        self.customize = customize
    }

    func makeCoordinator() -> TargetCache {
        TargetCache()
    }

    func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
        let controller = IntrospectionPlatformViewController { controller in
            guard let target = selector(controller) else {
                return
            }
            context.coordinator.target = target
            customize(target)
            controller.handler = nil
        }

        // - Workaround -
        // iOS/tvOS 13 sometimes need a nudge on the next run loop.
        if #available(iOS 14, tvOS 14, *) {} else {
            DispatchQueue.main.async { [weak controller] in
                controller?.handler?()
            }
        }

        return controller
    }

    func updatePlatformViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        guard let target = context.coordinator.target ?? selector(controller) else {
            return
        }
        customize(target)
    }

    static func dismantlePlatformViewController(_ controller: IntrospectionPlatformViewController, coordinator: Coordinator) {
        controller.handler = nil
    }
}

final class IntrospectionPlatformViewController: PlatformViewController {
    var handler: (() -> Void)? = nil

    fileprivate init(handler: ((IntrospectionPlatformViewController) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.handler = { [weak self] in
            guard let self = self else {
                return
            }
            handler?(self)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    #if canImport(UIKit)
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        handler?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
