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
            guard let targetView = self.selector(uiView) else {
                print("Couldn't find a view of type \(ViewType.self). Please make sure you apply introspect*() on a subview of the element to introspect.")
                return
            }
            self.customize(targetView)
        }
    }
}

public struct IntrospectionViewController<ViewControllerType: UIViewController>: UIViewControllerRepresentable {
    
    let selector: (UIViewController) -> ViewControllerType?
    let customize: (ViewControllerType) -> Void
    
    public init(
        selector: @escaping (UIViewController) -> ViewControllerType?,
        customize: @escaping (ViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<IntrospectionViewController>
    ) -> UIViewController {
        return UIViewController(nibName: nil, bundle: nil)
    }
    
    public func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<IntrospectionViewController>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let hostingViewController = uiViewController.parent else {
                return
            }
            guard let targetView = self.selector(hostingViewController) else {
                print("Couldn't find a view controller of type \(ViewControllerType.self). Please make sure you apply introspect*() on a subview of the element to introspect.")
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
                Introspect.findAncestor(ofType: UITableView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> ()) -> some View {
        return background(IntrospectionViewController(
            selector: { $0.navigationController },
            customize: customize
        ))
    }

}
