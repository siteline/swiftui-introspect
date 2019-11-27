import SwiftUI

public enum Introspect {
    
    public static func findChild<AnyViewType: UIView>(
        ofType type: AnyViewType.Type,
        in root: UIView
    ) -> AnyViewType? {
        for subview in root.subviews {
            if let typed = subview as? AnyViewType {
                return typed
            } else if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        return nil
    }
    
    public static func firstSibling<AnyViewType: UIView>(
        containing type: AnyViewType.Type,
        from entry: UIView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }
        
        for subview in superview.subviews[entryIndex...superview.subviews.count - 1] {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
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
    
    public static func findHostingView(from entry: UIView) -> UIView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("UIHostingView") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
    
    public static func findViewHost(from entry: UIView) -> UIView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
}

// Allows to safely access an array element by index
// Usage: array[safe: 2]
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
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
        let view = UIView(frame: .zero)
        view.accessibilityLabel = "IntrospectionUIView<\(ViewType.self)>"
        return view
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
            selector: { introspectionView in
                Introspect.findAncestor(ofType: UITableView.self, from: introspectionView)
            },
            customize: customize
        ))
    }
    
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        return background(IntrospectionView(
            selector: { introspectionView in
                Introspect.findAncestor(ofType: UIScrollView.self, from: introspectionView)
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
    
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        return self.background(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.firstSibling(containing: UITextField.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        return self.background(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.firstSibling(containing: UISwitch.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        return self.background(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.firstSibling(containing: UISlider.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        return self.background(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.firstSibling(containing: UIStepper.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        return self.background(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.firstSibling(containing: UIDatePicker.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
