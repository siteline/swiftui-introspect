#if canImport(UIKit)
import SwiftUI
import UIKit

/// Introspection UIViewController that is inserted alongside the target view controller.
public class IntrospectionUIViewController: UIViewController {

    fileprivate var viewDidLayoutSubviewsHandler: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.isHidden = true
        view.isAccessibilityElement = false
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 0),
            view.heightAnchor.constraint(equalToConstant: 0),
        ])
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsHandler?()
    }

    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            viewDidLayoutSubviewsHandler = nil
        }
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct UIKitIntrospectionViewController<Target>: UIViewControllerRepresentable {
    
    private let selector: (UIViewController) -> Target?
    private let customize: (Target) -> Void
    
    public init(
        selector: @escaping (UIViewController) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<UIKitIntrospectionViewController>
    ) -> IntrospectionUIViewController {
        let viewController = IntrospectionUIViewController()
        viewController.accessibilityLabel = "IntrospectionUIViewController<\(Target.self)>"
        viewController.viewDidLayoutSubviewsHandler = { [weak viewController] in
            guard let viewController = viewController else { return }
            guard let targetView = self.selector(viewController) else {
                return
            }
            self.customize(targetView)
        }
        return viewController
    }

    /// SwiftUI state changes after `makeUIViewController` will trigger this function,
    /// so we need to call the handler again to allow re-customization
    /// based on the newest state.
    public func updateUIViewController(
        _ viewController: IntrospectionUIViewController,
        context: UIViewControllerRepresentableContext<UIKitIntrospectionViewController>
    ) {
        guard let targetView = self.selector(viewController) else {
            return
        }
        self.customize(targetView)
    }

    /// Avoid memory leaks.
    public static func dismantleUIViewController(_ viewController: IntrospectionUIViewController, coordinator: ()) {
        viewController.viewDidLayoutSubviewsHandler = nil
    }
}
#endif
