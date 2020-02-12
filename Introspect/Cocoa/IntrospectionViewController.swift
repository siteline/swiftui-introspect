import SwiftUI
import Cocoa

/// Introspection NSViewController that is inserted alongside the target view controller.
public class IntrospectionNSViewController: NSViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
        view = IntrospectionNSView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct IntrospectionViewController<TargetViewControllerType: NSViewController>: NSViewControllerRepresentable {
    
    let selector: (IntrospectionNSViewController) -> TargetViewControllerType?
    let customize: (TargetViewControllerType) -> Void
    
    public init(
        selector: @escaping (IntrospectionNSViewController) -> TargetViewControllerType?,
        customize: @escaping (TargetViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeNSViewController(
        context: NSViewControllerRepresentableContext<IntrospectionViewController>
    ) -> IntrospectionNSViewController {
        let viewController = IntrospectionNSViewController()
        viewController.view.setAccessibilityLabel("IntrospectionNSView<\(TargetViewControllerType.self)>")
        return viewController
    }
    
    public func updateNSViewController(
        _ nsViewController: IntrospectionNSViewController,
        context: NSViewControllerRepresentableContext<IntrospectionViewController>
    ) {
        DispatchQueue.main.async {
            guard let targetView = self.selector(nsViewController) else {
                return
            }
            self.customize(targetView)
        }
    }
}
