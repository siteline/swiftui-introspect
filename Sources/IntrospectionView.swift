import SwiftUI

//struct IntrospectionView<Target: AnyObject>: PlatformViewControllerRepresentable {
//    final class TargetCache {
//        weak var target: Target?
//    }
//
//    @Binding
//    private var observed: Void // workaround for state changes not triggering view updates
//    private let selector: (IntrospectionPlatformViewController) -> Target?
//    private let customize: (Target) -> Void
//
//}

//extension View {
//    @ViewBuilder
//    func withAnchorID<Content: View, MainContent: View>(
//        @ViewBuilder content: @escaping (Content, IntrospectionAnchorView.ID) -> MainContent
//    ) -> some View {
//        self.modifier(IntrospectionAnchorIDViewModifier(mainContent: content))
//    }
//}

struct IntrospectionAnchorIDViewModifier: ViewModifier {
    let id: IntrospectionAnchorView.ID
    let mainContent: (Content, IntrospectionAnchorView.ID) -> AnyView

    init(
        id: IntrospectionAnchorView.ID = UUID(),
        @ViewBuilder mainContent: @escaping (Content, IntrospectionAnchorView.ID) -> some View
    ) {
        self.id = id
        self.mainContent = { AnyView(mainContent($0, $1)) }
    }

    func body(content: Content) -> some View {
        mainContent(content, id)
    }
}

/// ⚓️
struct IntrospectionAnchorView: PlatformViewRepresentable {
    typealias ID = UUID

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates

    let id: ID

    init(id: ID) {
        self._observed = .constant(())
        self.id = id
    }

    #if canImport(UIKit)
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.tag = id.hashValue
        return view
    }
    func updateUIView(_ controller: UIView, context: Context) {}
    #elseif canImport(AppKit)
    func makeNSView(context: Context) -> NSView {
        final class TaggableView: NSView {
            private var _tag: Int?
            override var tag: Int {
                get { _tag ?? super.tag }
                set { _tag = newValue }
            }
        }
        let view = TaggableView()
        view.tag = id.hashValue
        return view
    }
    func updateNSView(_ controller: NSView, context: Context) {}
    #endif
}

struct IntrospectionView<Target: AnyObject>: PlatformViewControllerRepresentable {
    final class TargetCache {
        weak var target: Target?
    }

    @Binding
    private var observed: Void // workaround for state changes not triggering view updates
    private let selector: (IntrospectionPlatformViewController) -> Target?
    private let customize: (Target) -> Void

    init(
        selector: @escaping (PlatformView) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self._observed = .constant(())
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
        self.selector = { selector($0) }
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
