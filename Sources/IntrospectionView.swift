import SwiftUI

fileprivate enum IntrospectionTargetType {
    case view
    case viewController
}

struct IntrospectionView<Target>: PlatformViewControllerRepresentable {
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

    func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
        let controller = IntrospectionPlatformViewController(targetType: targetType) { controller in
            guard let target = selector(controller) else {
                return
            }
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
        guard let target = selector(controller) else {
            return
        }
        customize(target)
    }

    static func dismantlePlatformViewController(_ controller: IntrospectionPlatformViewController, coordinator: ()) {
        controller.handler = nil
    }
}

final class IntrospectionPlatformViewController: PlatformViewController {
    static let viewTag = "IntrospectionPlatformViewController.View".hashValue

    fileprivate let targetType: IntrospectionTargetType
    var handler: (() -> Void)? = nil

    fileprivate init(targetType: IntrospectionTargetType, handler: ((IntrospectionPlatformViewController) -> Void)?) {
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
        switch targetType {
        case .view:
            guard #available(iOS 14, tvOS 14, *) else {
                return // too premature for iOS/tvOS 13, so we skip
            }
            handler?()
        case .viewController:
            handler?() // should always be hit for controllers
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tag = Self.viewTag
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch targetType {
        case .view:
            guard #available(iOS 14, tvOS 14, *) else {
                return // too premature for iOS/tvOS 13, so we skip
            }
            handler?() // optimistic, will be called most times for view targets
        case .viewController:
            break // should never be hit for controllers
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch targetType {
        case .view:
            handler?() // first entry point for iOS 13, and fallback for some views on iOS 14 which start as 0-sized (e.g. List)
        case .viewController:
            break // should never be hit for controllers
        }
    }
    #elseif canImport(AppKit)
    final class View: NSView {
        override var tag: Int { viewTag }
    }

    override func loadView() {
        view = View()
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
