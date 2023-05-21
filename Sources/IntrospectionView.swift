import SwiftUI

enum IntrospectionTargetType {
    case view
    case viewController
}

struct IntrospectionView<Observed, Target>: PlatformViewControllerRepresentable {
    @Binding
    var observed: Observed
    let targetType: IntrospectionTargetType
    let selector: (PlatformViewController) -> Target?
    let customize: (Target) -> Void

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
    let targetType: IntrospectionTargetType
    var handler: (() -> Void)?

    init(targetType: IntrospectionTargetType, handler: ((IntrospectionPlatformViewController) -> Void)?) {
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
