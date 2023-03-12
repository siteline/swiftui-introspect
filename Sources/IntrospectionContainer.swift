import SwiftUI

final class IntrospectionContainerHostingController<Content: View>: UIHostingController<Content> {
    var viewDidLayoutSubviewsHandler: (() -> Void)?

//    private var heightConstraint: NSLayoutConstraint?

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        view.sizeToFit()
//        view.invalidateIntrinsicContentSize()
    }

    override func viewDidLoad() {
            super.viewDidLoad()
//            if #available(iOS 15.0, *) {
//                heightConstraint = view.heightAnchor.constraint(equalToConstant: view.intrinsicContentSize.height)
//                NSLayoutConstraint.activate([
//                    heightConstraint!,
//                ])
//            }
        }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsHandler?()

//        view.setNeedsUpdateConstraints()
//        let originalOrigin = view.frame.origin
//        view.sizeToFit()
//        view.frame.origin = originalOrigin
//        view.frame.size = view.intrinsicContentSize
//        view.frame.size.width = view.intrinsicContentSize.width

//        heightConstraint?.constant = view.intrinsicContentSize.height
    }
}

struct IntrospectionContainer<Observed, Target: PlatformView, Content: View>: UIViewRepresentable {
    @Binding
    var observed: Observed
    let selector: (UIView) -> Target?
    let customize: (Target, Observed) -> Void
    @ViewBuilder
    let content: () -> Content

    func makeCoordinator() -> IntrospectionContainerHostingController<Content> {
        IntrospectionContainerHostingController(rootView: content())
    }

    func makeUIView(context: Context) -> UIView {
        let host = context.coordinator
        host.view.backgroundColor = .blue
        host.view.accessibilityLabel = "IntrospectionContainer<\(Target.self)>"

//        host.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        host.view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        host.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        host.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        host.view.translatesAutoresizingMaskIntoConstraints = false
//        host.view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight]
        host.viewDidLayoutSubviewsHandler = { [weak host] in
            guard let host = host else { return }
            guard let target = selector(host.view) else {
                return
            }
            self.customize(target, observed)
            host.viewDidLayoutSubviewsHandler = nil
        }
        return host.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let target = selector(uiView) else {
            return
        }
        self.customize(target, observed)
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: IntrospectionContainerHostingController<Content>) {
        coordinator.viewDidLayoutSubviewsHandler = nil
    }
}
