import SwiftUI

public typealias IntrospectionContainerID = UUID

final class IntrospectionContainerHostingController<Content: View>: UIHostingController<Content> {
    var viewDidLayoutSubviewsHandler: (() -> Void)?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsHandler?()
    }
}

struct IntrospectionContainer<Target: UIView, Content: View>: UIViewRepresentable {
//    let id: IntrospectionContainerID
//    @Binding
//    var observed: Observed
    let selector: (UIView) -> Target?
    let customize: (Target) -> Void
    @ViewBuilder
    let content: () -> Content

//    init(
//        id: IntrospectionContainerID,
////        observed: @escaping () -> Observed,
//        selector: @escaping (UIView, IntrospectionContainerID) -> Target?,
//        customize: @escaping (Target) -> Void,
//        @ViewBuilder content: @escaping () -> Content
//    ) {
//        self.id = id
////        self._observed = .init(get: observed, set: { _ in })
//        self.selector = selector
//        self.customize = customize
//        self.content = content
//    }

    func makeUIView(context: Context) -> UIView {
        let host = IntrospectionContainerHostingController(rootView: content())
        host.view.backgroundColor = .clear
//        host.view.accessibilityIdentifier = id.uuidString
//        host.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        host.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.viewDidLayoutSubviewsHandler = { [weak host] in
            guard let host = host else { return }
            guard let targetView = self.selector(host.view) else {
                return
            }
            self.customize(targetView)
            host.viewDidLayoutSubviewsHandler = nil
        }
        return host.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let targetView = self.selector(uiView) else {
            return
        }
        self.customize(targetView)
    }
}

//enum IntrospectionTarget {
//    case receiver
//    case receiverOrAncestor
//}
