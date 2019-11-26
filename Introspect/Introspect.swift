import SwiftUI

public enum Introspect {
    public static func findChild<AnyViewType: UIView>(ofType type: AnyViewType.Type, in root: UIView) -> AnyViewType? {
        for subview in root.subviews {
            if let tableView = subview as? AnyViewType {
                return tableView
            } else if let tableView = findChild(ofType: type, in: subview) {
                return tableView
            }
        }
        return nil
    }
    
    public static func findAncestor<AnyViewType: UIView>(ofType type: AnyViewType.Type, from entry: UIView) -> AnyViewType? {
        var superview = entry.superview
        while let s = superview {
            if let typed = s as? AnyViewType {
                return typed
            }
            superview = s.superview
        }
        return nil
    }
}

public struct IntrospectionView<ViewType: UIView>: UIViewRepresentable {
    
    
    let selector: (UIView) -> ViewType?
    let customize: (ViewType) -> Void
    
    public init(
        selector: @escaping (UIView) -> ViewType?,
        customize: @escaping (ViewType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeUIView(context: UIViewRepresentableContext<IntrospectionView>) -> UIView {
        return UIView(frame: .zero)
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<IntrospectionView>) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let viewHost = uiView.superview?.superview else {
                return
            }
            guard let targetView = self.selector(viewHost) else {
                return
            }
            self.customize(targetView)
        }
    }
}


extension View {
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        return background(IntrospectionView(
            selector: { viewHost in
                Introspect.findChild(ofType: UITableView.self, in: viewHost)
            },
            customize: customize
        ))
    }
}
