#if canImport(UIKit)
import SwiftUI
import UIKit

/// Introspection UIViewController that is inserted alongside the target view controller.
public class IntrospectionUIViewController: UIViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
        view = IntrospectionUIView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct UIKitIntrospectionViewController<TargetViewControllerType: UIViewController>: UIViewControllerRepresentable {
    
    let selector: (IntrospectionUIViewController) -> TargetViewControllerType?
    let customize: (TargetViewControllerType) -> Void
    
    public init(
        selector: @escaping (UIViewController) -> TargetViewControllerType?,
        customize: @escaping (TargetViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    /// When `makeUIViewController` and `updateUIViewController` are called, the Introspection view is not yet in
    /// the UIKit hierarchy. At this point, `introspectionViewController.parent` is nil and we can't access the target
    /// UIKit view controller. To workaround this, we wait until the runloop is done inserting the introspection view controller's
    /// view in the hierarchy, then run the selector. Finding the target view controller fails silently if the selector yields no result.
    /// This happens when the introspection view controller's view gets removed from the hierarchy.
    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<UIKitIntrospectionViewController>
    ) -> IntrospectionUIViewController {
        let viewController = IntrospectionUIViewController()
        viewController.accessibilityLabel = "IntrospectionUIViewController<\(TargetViewControllerType.self)>"
        viewController.view.accessibilityLabel = "IntrospectionUIView<\(TargetViewControllerType.self)>"
        (viewController.view as? IntrospectionUIView)?.moveToWindowHandler = { [weak viewController] in
            guard let viewController = viewController else { return }
            DispatchQueue.main.async {
                guard let targetView = self.selector(viewController) else {
                    return
                }
                self.customize(targetView)
            }
        }
        return viewController
    }
    
    /// SwiftUI state changes after `makeUIViewController` will trigger this function, not
    /// `makeUIViewController`, so we need to call the handler again to allow re-customization
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
        (viewController.view as? IntrospectionUIView)?.moveToWindowHandler = nil
    }
}
#endif
