import SwiftUI

final class IntrospectionContainerHostingController<Content: View>: UIHostingController<Content> {
    var viewDidLayoutSubviewsHandler: (() -> Void)?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsHandler?()
    }
}

struct IntrospectionContainer<Observed, Target: UIView, Content: View>: UIViewRepresentable {
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
        host.view.backgroundColor = .clear
        host.view.accessibilityLabel = "IntrospectionContainer<\(Target.self)>"
//        host.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        host.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        host.view.translatesAutoresizingMaskIntoConstraints = false
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

@_spi(Internals)
public enum IntrospectionScope {
    case receiver
    case ancestor
    case receiverOrAncestor
}
