import SwiftUI

final class IntrospectionContainerHostingController<Content: View>: UIHostingController<Content> {
    var viewDidLayoutSubviewsHandler: (() -> Void)?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsHandler?()
    }
}

struct IntrospectionContainer<Observed, Target: PlatformView, Content: View>: UIViewControllerRepresentable {
    @Binding
    var observed: Observed
    let selector: (UIView) -> Target?
    let customize: (Target, Observed) -> Void
    @ViewBuilder
    let content: () -> Content

    typealias UIViewControllerType = IntrospectionContainerHostingController<Content>

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let host = IntrospectionContainerHostingController(rootView: content())
        host.view.backgroundColor = .blue
//        host.view.accessibilityLabel = "IntrospectionContainer<\(Target.self)>"

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
        return host
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let target = selector(uiViewController.view) else {
            return
        }
        self.customize(target, observed)
    }

    static func dismantleUIViewController(_ uiViewController: UIViewControllerType, coordinator: ()) {
        uiViewController.viewDidLayoutSubviewsHandler = nil
    }
}
