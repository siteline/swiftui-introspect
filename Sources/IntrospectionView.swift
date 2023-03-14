import SwiftUI

struct IntrospectionView<Observed, Target>: PlatformViewControllerRepresentable {
    @Binding
    var observed: Observed
    let selector: (PlatformViewController) -> Target?
    let customize: (Target, Observed) -> Void

    #if canImport(UIKit)
    func makeUIViewController(context: Context) -> IntrospectionPlatformViewController {
        makePlatformViewController(context: context)
    }
    func updateUIViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    static func dismantleUIViewController(_ controller: IntrospectionPlatformViewController, coordinator: ()) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #elseif canImport(AppKit)
    func makeNSViewController(context: Context) -> IntrospectionPlatformViewController {
        makePlatformViewController(context: context)
    }
    func updateNSViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    static func dismantleNSViewController(_ controller: IntrospectionPlatformViewController, coordinator: Coordinator) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #endif

    // TODO: in Swift 5.8
    // #if canImport(UIKit)
    // @_implements(Self, makeUIViewController)
    // #elseif canImport(AppKit)
    // @_implements(Self, makeNSViewController)
    // #endif
    private func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController {
        let controller = IntrospectionPlatformViewController()
        controller.handler = { [weak controller] in
            guard let controller = controller else { return }
            guard let target = selector(controller) else {
                return
            }
            customize(target, observed)
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

    // TODO: in Swift 5.8
    // #if canImport(UIKit)
    // @_implements(Self, updateUIViewController)
    // #elseif canImport(AppKit)
    // @_implements(Self, updateNSViewController)
    // #endif
    private func updatePlatformViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        guard let target = selector(controller) else {
            return
        }
        customize(target, observed)
    }

    // TODO: in Swift 5.8
    // #if canImport(UIKit)
    // @_implements(Self, dismantleUIViewController)
    // #elseif canImport(AppKit)
    // @_implements(Self, dismantleNSViewController)
    // #endif
    private static func dismantlePlatformViewController(_ controller: IntrospectionPlatformViewController, coordinator: ()) {
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
        handler?() // optimistic, will be called most times for view targets
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handler?() // backup for some views on iOS 14 which start as 0-sized (e.g. List)
    }
    #elseif canImport(AppKit)
    // TODO: didMove(toParent:) is not an AppKit API. What to do?

    override func loadView() {
        view = NSView()
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
