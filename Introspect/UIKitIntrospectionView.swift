#if canImport(UIKit)
import UIKit
import SwiftUI

/// Introspection UIView that is inserted alongside the target view.
public class IntrospectionUIView: UIView {
    
    var layoutSubviewsHandler: (() -> Void)?
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
        isAccessibilityElement = false
        isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        layoutSubviewsHandler?()
        super.layoutSubviews()
        layoutSubviewsHandler = nil
    }
}

/// Introspection View that is injected into the UIKit hierarchy alongside the target view.
/// After `updateUIView` is called, it calls `selector` to find the target view, then `customize` when the target view is found.
public struct UIKitIntrospectionView<TargetViewType: UIView>: UIViewRepresentable {
    
    /// Method that introspects the view hierarchy to find the target view.
    /// First argument is the introspection view itself, which is contained in a view host alongside the target view.
    let selector: (IntrospectionUIView) -> TargetViewType?
    
    /// User-provided customization method for the target view.
    let customize: (TargetViewType) -> Void
    
    public init(
        selector: @escaping (IntrospectionUIView) -> TargetViewType?,
        customize: @escaping (TargetViewType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }

    public func makeUIView(context: UIViewRepresentableContext<UIKitIntrospectionView>) -> IntrospectionUIView {
        let view = IntrospectionUIView()
        view.accessibilityLabel = "IntrospectionUIView<\(TargetViewType.self)>"
        view.layoutSubviewsHandler = { [weak view] in
            guard let view = view else { return }
            guard let targetView = self.selector(view) else {
                return
            }
            self.customize(targetView)
        }
        return view
    }
    
    /// SwiftUI state changes after `makeUIView` will trigger this function,
    /// so we need to call the handler again to allow re-customization
    /// based on the newest state.
    public func updateUIView(
        _ view: IntrospectionUIView,
        context: UIViewRepresentableContext<UIKitIntrospectionView>
    ) {
        guard let targetView = self.selector(view) else {
            return
        }
        self.customize(targetView)
    }
    
    /// Avoid memory leaks.
    public static func dismantleUIView(_ view: IntrospectionUIView, coordinator: ()) {
        view.layoutSubviewsHandler = nil
    }
}
#endif
