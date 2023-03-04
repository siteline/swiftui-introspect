#if canImport(UIKit)
import UIKit
import SwiftUI

/// Introspection UIView that is inserted alongside the target view.
public class IntrospectionUIView: UIView {

    var didMoveToWindowHandler: (() -> Void)?
//    var willMoveToSuperview: ((UIView) -> Void)?

    required init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
        backgroundColor = .clear

//        translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            widthAnchor.constraint(equalToConstant: 1),
//            heightAnchor.constraint(equalToConstant: 1),
//        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    public override func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        print("super.willMove(toSuperview: newSuperview)")
//        guard let newSuperview = newSuperview else { return }
//        willMoveToSuperview?(newSuperview)
//        print(newSuperview)
//        print(newSuperview.superview)
//    }

//    public override func willMove(toWindow newWindow: UIWindow?) {
//        super.willMove(toWindow: newWindow)
//        print("super.willMove(toWindow: newWindow)")
////        willMoveToSuperview?(superview)
//    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        print("super.didMoveToWindow")
        guard window != nil else { return }
        didMoveToWindowHandler?()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
//        layoutSubviewsHandler?()
        print("layoutSubviews")
    }
}

public protocol IntrospectionView: View {
    var containerID: IntrospectionContainerID { get }
}

/// Introspection View that is injected into the UIKit hierarchy alongside the target view.
/// After `updateUIView` is called, it calls `selector` to find the target view, then `customize` when the target view is found.
public struct UIKitIntrospectionView<Target: UIView>: UIViewRepresentable, IntrospectionView {

    public let containerID: IntrospectionContainerID

    /// Method that introspects the view hierarchy to find the target view.
    /// First argument is the introspection view itself, which is contained in a view host alongside the target view.
    let selector: (UIView, IntrospectionContainerID) -> Target?

    /// User-provided customization method for the target view.
    let customize: (Target) -> Void

    public init(
        containerID: UUID,
        selector: @escaping (UIView, IntrospectionContainerID) -> Target?,
        customize: @escaping (Target) -> Void
    ) {
        self.containerID = containerID
        self.selector = selector
        self.customize = customize
    }

    /// When `makeUIView` and `updateUIView` are called, the Introspection view is not yet in the UIKit hierarchy.
    /// At this point, `introspectionView.superview.superview` is nil and we can't access the target UIKit view.
    /// To workaround this, we wait until the runloop is done inserting the introspection view in the hierarchy, then run the selector.
    /// Finding the target view fails silently if the selector yields no result. This happens when the introspection view gets
    /// removed from the hierarchy.
    public func makeUIView(context: UIViewRepresentableContext<UIKitIntrospectionView>) -> IntrospectionUIView {
        let view = IntrospectionUIView()
        view.accessibilityLabel = "IntrospectionUIView<\(Target.self)>"
        view.didMoveToWindowHandler = { [weak view] in
            guard let view = view else { return }
            guard let targetView = self.selector(view, containerID) else {
                return
            }
            self.customize(targetView)
            view.didMoveToWindowHandler = nil
        }
        return view
    }

    /// SwiftUI state changes after `makeUIView` will trigger this function, not
    /// `makeUIView`, so we need to call the handler again to allow re-customization
    /// based on the newest state.
    public func updateUIView(
        _ view: IntrospectionUIView,
        context: UIViewRepresentableContext<UIKitIntrospectionView>
    ) {
        guard let targetView = self.selector(view, containerID) else {
            return
        }
        self.customize(targetView)
    }

    /// Avoid memory leaks.
    public static func dismantleUIView(_ view: IntrospectionUIView, coordinator: ()) {
        view.didMoveToWindowHandler = nil
    }
}
#endif
