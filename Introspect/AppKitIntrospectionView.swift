#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import SwiftUI
import AppKit

/// Introspection NSView that is inserted alongside the target view.
@available(macOS 10.15.0, *)
public class IntrospectionNSView: NSView {
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
    }
    
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Introspection View that is injected into the UIKit hierarchy alongside the target view.
/// After `updateNSView` is called, it calls `selector` to find the target view, then `customize` when the target view is found.
@available(macOS 10.15.0, *)
public struct AppKitIntrospectionView<TargetViewType: NSView>: NSViewRepresentable {
    
    /// Method that introspects the view hierarchy to find the target view.
    /// First argument is the introspection view itself, which is contained in a view host alongside the target view.
    let selector: (IntrospectionNSView) -> TargetViewType?
    
    /// User-provided customization method for the target view.
    let customize: (TargetViewType) -> Void
    
    public init(
        selector: @escaping (IntrospectionNSView) -> TargetViewType?,
        customize: @escaping (TargetViewType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeNSView(context: NSViewRepresentableContext<AppKitIntrospectionView>) -> IntrospectionNSView {
        let view = IntrospectionNSView()
        view.setAccessibilityLabel("IntrospectionNSView<\(TargetViewType.self)>")
        return view
    }

    /// When `updateNSView` is called after creating the Introspection view, it is not yet in the AppKit hierarchy.
    /// At this point, `introspectionView.superview.superview` is nil and we can't access the target AppKit view.
    /// To workaround this, we wait until the runloop is done inserting the introspection view in the hierarchy, then run the selector.
    /// Finding the target view fails silently if the selector yield no result. This happens when `updateNSView`
    /// gets called when the introspection view gets removed from the hierarchy.
    public func updateNSView(
        _ nsView: IntrospectionNSView,
        context: NSViewRepresentableContext<AppKitIntrospectionView>
    ) {
        DispatchQueue.main.async {
            guard let targetView = self.selector(nsView) else {
                return
            }
            self.customize(targetView)
        }
    }
}
#endif

