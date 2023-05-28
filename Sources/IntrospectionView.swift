import SwiftUI

fileprivate enum IntrospectionTargetType {
    case view
    case viewController
}

/// ⚓️
struct IntrospectionAnchorView: PlatformViewRepresentable {
    #if canImport(UIKit)
    typealias TaggableView = UIView
    #elseif canImport(AppKit)
    final class TaggableView: NSView {
        let _tag: Int?

        init(tag: Int?) {
            self._tag = tag
            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var tag: Int { _tag ?? super.tag }
    }
    #endif

    typealias ID = UUID

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates

    let id: ID

    init(id: ID) {
        self._observed = .constant(()) // workaround for state changes not triggering view updates
        self.id = id
    }

    #if canImport(UIKit)
    func makeUIView(context: Context) -> TaggableView {
        let view = TaggableView()
        view.tag = id.hashValue
        return view
    }
    func updateUIView(_ controller: TaggableView, context: Context) {}
    static func dismantleUIView(_ controller: TaggableView, coordinator: Coordinator) {}
    #elseif canImport(AppKit)
    func makeNSView(context: Context) -> TaggableView {
        TaggableView(tag: id.hashValue)
    }
    func updateNSView(_ controller: TaggableView, context: Context) {}
    static func dismantleNSView(_ controller: TaggableView, coordinator: Coordinator) {}
    #endif
}

struct IntrospectionView<Target: AnyObject>: PlatformViewControllerRepresentable {
    final class TargetCache {
        weak var target: Target?
    }

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates
    private let targetType: IntrospectionTargetType
    private let selector: (IntrospectionPlatformViewController) -> Target?
    private let customize: (Target) -> Void

    init(
        selector: @escaping (PlatformView) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self._observed = .constant(())
        self.targetType = .view
        self.selector = { introspectionViewController in
            #if canImport(UIKit)
            if let introspectionView = introspectionViewController.viewIfLoaded {
                return selector(introspectionView)
            }
            #elseif canImport(AppKit)
            if introspectionViewController.isViewLoaded {
                return selector(introspectionViewController.view)
            }
            #endif
            return nil
        }
        self.customize = customize
    }

    init(
        selector: @escaping (PlatformViewController) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self._observed = .constant(())
        self.targetType = .viewController
        self.selector = { selector($0) }
        self.customize = customize
    }

    func makeCoordinator() -> TargetCache {
        TargetCache()
    }

    func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
        let controller = IntrospectionPlatformViewController(targetType: targetType) { controller in
            guard let target = selector(controller) else {
                return
            }
            context.coordinator.target = target
            customize(target)
            controller.handler = nil
        }

        // - Workaround -
        // iOS/tvOS 13 sometimes need a nudge on the next run loop.
        // Comment this out and run Showcase on iOS/tvOS 13 to see why.
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
    fileprivate let targetType: IntrospectionTargetType
    var handler: (() -> Void)? = nil

    fileprivate init(
        targetType: IntrospectionTargetType,
        handler: ((IntrospectionPlatformViewController) -> Void)?
    ) {
        self.targetType = targetType
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

    override func viewDidLayout() {
        super.viewDidLayout()
        handler?()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        handler?()
    }
    #endif
}
