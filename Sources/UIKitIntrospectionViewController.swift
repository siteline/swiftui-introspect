#if canImport(UIKit)
import SwiftUI
import UIKit

/// Introspection UIViewController that is inserted alongside the target view controller.
public class IntrospectionUIViewController: UIViewController {

    fileprivate var viewDidLayoutSubviewsHandler: (() -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)
        view.isHidden = true
        view.isAccessibilityElement = false
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 0),
            view.heightAnchor.constraint(equalToConstant: 0),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

//        view.setNeedsUpdateConstraints()
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
    }

//    public override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        print("didMove")
//    }

    public override func viewDidLayoutSubviews() {
        self.viewDidLayoutSubviewsHandler?()
        print("viewDidLayoutSubviewsHandler")
//        print(view)
    }

    public override func didMove(toParent parent: UIViewController?) {
        print("didMove", parent)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }

    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        print("willMove", parent)
        if parent == nil {
            viewDidLayoutSubviewsHandler = nil
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
//        self.viewDidLayoutSubviewsHandler?()
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct UIKitIntrospectionViewController<Target>: UIViewControllerRepresentable, Identifiable {

    public let id: IntrospectionContainerID

    private let selector: (UIViewController, IntrospectionContainerID) -> Target?
    private let customize: (Target) -> Void
    
    public init(
        selector: @escaping (UIViewController, IntrospectionContainerID) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self.id = UUID()
        self.selector = selector
        self.customize = customize
    }

    @_disfavoredOverload
    public init(
        selector: @escaping (UIView, IntrospectionContainerID) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self.init(
            selector: { selector($0.view, $1) },
            customize: customize
        )
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<UIKitIntrospectionViewController>
    ) -> IntrospectionUIViewController {
        let viewController = IntrospectionUIViewController()
        viewController.accessibilityLabel = "IntrospectionUIViewController<\(Target.self)>"
        viewController.viewDidLayoutSubviewsHandler = { [weak viewController] in
            guard let viewController = viewController else { return }
            guard let targetView = self.selector(viewController, id) else {
                return
            }
            self.customize(targetView)
            viewController.viewDidLayoutSubviewsHandler = nil
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
        guard let targetView = self.selector(viewController, id) else {
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
