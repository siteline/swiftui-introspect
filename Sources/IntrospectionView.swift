import SwiftUI

struct IntrospectionView<Observed, Target>: PlatformViewControllerRepresentable {
    @Binding
    var observed: Observed
    let selector: (PlatformViewController) -> Target?
    let customize: (Target) -> Void

    func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
        let controller = IntrospectionPlatformViewController()
        controller.handler = { [weak controller] in
            guard let controller = controller else { return }
            guard let target = selector(controller) else {
                return
            }
            customize(target)
            controller.handler = nil
        }

        // - Workaround -
        // iOS 13 sometimes needs a nudge on the next run loop.
        // Comment this out and run Showcase on iOS 13 to see why.
        if #available(iOS 14, *) {} else {
            DispatchQueue.main.async { [weak controller] in
                guard let controller = controller else { return }
                controller.handler?()
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
    var handler: (() -> Void)?

    #if canImport(UIKit)
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        handler?() // will always be called for controller targets
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 14, *) {
            handler?() // optimistic, will be called most times for view targets (except for iOS 13 where it's too premature)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handler?() // backup for some views on iOS 14 which start as 0-sized (e.g. List), and iOS 13
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
