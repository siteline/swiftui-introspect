import SwiftUI

#if os(macOS)
public typealias PlatformView = NSView
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformView = UIView
#endif

#if os(macOS)
public typealias PlatformViewController = NSViewController
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewController = UIViewController
#endif

#if os(macOS)
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif

#if os(macOS)
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#endif

#if os(macOS)
public typealias PlatformTableView = NSTableView
public typealias PlatformScrollView = NSScrollView
public typealias PlatformTextField = NSTextField
public typealias PlatformSwitch = NSSwitch
public typealias PlatformSlider = NSSlider
public typealias PlatformStepper = NSStepper
public typealias PlatformDatePicker = NSDatePicker
public typealias PlatformSegmentedControl = NSSegmentedControl
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformTableView = UITableView
public typealias PlatformScrollView = UIScrollView
public typealias PlatformTextField = UITextField
@available(tvOS, unavailable)
public typealias PlatformSwitch = UISwitch
@available(tvOS, unavailable)
public typealias PlatformSlider = UISlider
@available(tvOS, unavailable)
public typealias PlatformStepper = UIStepper
@available(tvOS, unavailable)
public typealias PlatformDatePicker = UIDatePicker
public typealias PlatformSegmentedControl = UISegmentedControl
#endif


/// Utility methods to inspect the UIKit view hierarchy.
public enum Introspect {
    
    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        in root: PlatformView
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
    
    /// Finds a child view controller of the specified type.
    /// This method will recursively look for this child.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        in root: PlatformViewController
    ) -> AnyViewControllerType? {
        for child in root.children {
            if let typed = child as? AnyViewControllerType {
                return typed
            } else if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }
        return nil
    }
    
    /// Finds a previous sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for subview in superview.subviews[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a previous sibling that contains a view controller of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        containing type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {
        
        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a previous sibling that is a view controller of the specified type.
    /// This method does not inspect siblings recursively.
    /// Returns nil if no sibling is of the specified type.
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {
        
        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = child as? AnyViewControllerType {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a next sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func nextSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }
        
        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds an ancestor of the specified type.
    /// If it reaches the top of the view without finding the specified view type, it returns nil.
    public static func findAncestor<AnyViewType: PlatformView>(ofType type: AnyViewType.Type, from entry: PlatformView) -> AnyViewType? {
        var superview = entry.superview
        while let s = superview {
            if let typed = s as? AnyViewType {
                return typed
            }
            superview = s.superview
        }
        return nil
    }
    
    /// Finds the hosting view of a specific subview.
    /// Hosting views generally contain subviews for one specific SwiftUI element.
    /// For instance, if there are multiple text fields in a VStack, the hosting view will contain those text fields (and their host views, see below).
    /// Returns nil if it couldn't find a hosting view. This should never happen when called with an IntrospectionView.
    public static func findHostingView(from entry: PlatformView) -> PlatformView? {
        var superview = entry.superview
        while let s = superview {
            #if os(iOS) || os(tvOS)
            if NSStringFromClass(type(of: s)).contains("UIHostingView") {
                return s
            }
            #endif
            #if os(macOS)
            if NSStringFromClass(type(of: s)).contains("NSHostingView") {
                return s
            }
            #endif
            superview = s.superview
        }
        return nil
    }
    
    /// Finds the view host of a specific view.
    /// SwiftUI wraps each UIView within a ViewHost, then within a HostingView.
    /// Returns nil if it couldn't find a view host. This should never happen when called with an IntrospectionView.
    public static func findViewHost(from entry: PlatformView) -> PlatformView? {
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

/// Allows to safely access an array element by index
/// Usage: array[safe: 2]
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

/// Introspection UIView that is inserted alongside the target view.
public class IntrospectionPlatformView: PlatformView {
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
        #if os(iOS) || os(tvOS)
        isUserInteractionEnabled = false
        #endif
    }
    
    #if os(macOS)
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
    #endif
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Introspection View that is injected into the UIKit hierarchy alongside the target view.
/// After `updateUIView` is called, it calls `selector` to find the target view, then `customize` when the target view is found.
public struct IntrospectionView<TargetViewType: PlatformView>: PlatformViewRepresentable {
    
    /// Method that introspects the view hierarchy to find the target view.
    /// First argument is the introspection view itself, which is contained in a view host alongside the target view.
    let selector: (IntrospectionPlatformView) -> TargetViewType?
    
    /// User-provided customization method for the target view.
    let customize: (TargetViewType) -> Void
    
    public init(
        selector: @escaping (PlatformView) -> TargetViewType?,
        customize: @escaping (TargetViewType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    #if os(iOS) || os(tvOS)
    public func makeUIView(context: Context) -> IntrospectionPlatformView {
        makeView(context: context)
    }
    #endif
    #if os(macOS)
    public func makeNSView(context: Context) -> IntrospectionPlatformView {
        makeView(context: context)
    }
    #endif
    
    internal func makeView(context: Context) -> IntrospectionPlatformView {
        let view = IntrospectionPlatformView()
        #if os(iOS) || os(tvOS)
        view.accessibilityLabel = "IntrospectionPlatformView<\(TargetViewType.self)>"
        #else
        view.setAccessibilityLabel("IntrospectionPlatformView<\(TargetViewType.self)>")
        #endif
        return view
    }
    
    #if os(iOS) || os(tvOS)
    public func updateUIView(_ uiView: IntrospectionPlatformView, context: Context) {
        updateView(uiView, context: context)
    }
    #endif
    #if os(macOS)
    public func updateNSView(_ nsView: IntrospectionPlatformView, context: Context) {
        updateView(nsView, context: context)
    }
    #endif

    /// When `updateUiView` is called after creating the Introspection view, it is not yet in the UIKit hierarchy.
    /// At this point, `introspectionView.superview.superview` is nil and we can't access the target UIKit view.
    /// To workaround this, we wait until the runloop is done inserting the introspection view in the hierarchy, then run the selector.
    /// Finding the target view fails silently if the selector yield no result. This happens when `updateUIView`
    /// gets called when the introspection view gets removed from the hierarchy.
    internal func updateView(_ view: IntrospectionPlatformView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(view) else {
                return
            }
            self.customize(targetView)
        }
    }
}

/// Introspection UIViewController that is inserted alongside the target view controller.
public class IntrospectionPlatformViewController: PlatformViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
        view = IntrospectionPlatformView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct IntrospectionViewController<TargetViewControllerType: PlatformViewController>: PlatformViewControllerRepresentable {
    
    let selector: (IntrospectionPlatformViewController) -> TargetViewControllerType?
    let customize: (TargetViewControllerType) -> Void
    
    public init(
        selector: @escaping (PlatformViewController) -> TargetViewControllerType?,
        customize: @escaping (TargetViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    #if os(iOS) || os(tvOS)
    public func makeUIViewController(context: Context) -> IntrospectionPlatformViewController {
        makeViewController(context: context)
    }
    #endif
    #if os(macOS)
    public func makeNSViewController(context: Context) -> IntrospectionPlatformViewController {
        makeViewController(context: context)
    }
    #endif
    
    internal func makeViewController(context: Context) -> IntrospectionPlatformViewController {
        let viewController = IntrospectionPlatformViewController()
        #if os(iOS) || os(tvOS)
        viewController.accessibilityLabel = "IntrospectionPlatformViewController<\(TargetViewControllerType.self)>"
        viewController.view.accessibilityLabel = "IntrospectionPlatformView<\(TargetViewControllerType.self)>"
        #endif
        #if os(macOS)
        viewController.view.setAccessibilityLabel("IntrospectionPlatformView<\(TargetViewControllerType.self)>")
        #endif
        return viewController
    }
    
    #if os(iOS) || os(tvOS)
    public func updateUIViewController(_ uiViewController: IntrospectionPlatformViewController, context: Context) {
        updateViewController(uiViewController, context: context)
    }
    #endif
    #if os(macOS)
    public func updateNSViewController(_ nsViewController: IntrospectionPlatformViewController, context: Context) {
        updateViewController(nsViewController, context: context)
    }
    #endif
    
    internal func updateViewController(_ viewController: IntrospectionPlatformViewController, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(viewController) else {
                return
            }
            self.customize(targetView)
        }
    }
}


extension View {
    
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (PlatformTableView) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in

                // Search in ancestors
                if let tableView = Introspect.findAncestor(ofType: PlatformTableView.self, from: introspectionView) {
                    return tableView
                }

                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }

                // Search in siblings
                return Introspect.previousSibling(containing: PlatformTableView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (PlatformScrollView) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                
                // Search in ancestors
                if let tableView = Introspect.findAncestor(ofType: PlatformScrollView.self, from: introspectionView) {
                    return tableView
                }
                
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                
                // Search in siblings
                return Introspect.previousSibling(containing: PlatformScrollView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    #if os(iOS) || os(tvOS)
    /// Finds a `UINavigationController` from any view embedded in a `SwiftUI.NavigationView`.
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> ()) -> some View {
        return inject(IntrospectionViewController(
            selector: { introspectionViewController in
                
                // Search in ancestors
                if let navigationController = introspectionViewController.navigationController {
                    return navigationController
                }
                
                // Search in siblings
                return Introspect.previousSibling(containing: UINavigationController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }
    #endif
    
    /// Finds the containing `UIViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (PlatformViewController) -> ()) -> some View {
        return inject(IntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }

    #if os(iOS) || os(tvOS)
    /// Finds a `UITabBarController` from any SwiftUI view embedded in a `SwiftUI.TabView`
    public func introspectTabBarController(customize: @escaping (UITabBarController) -> ()) -> some View {
        return inject(IntrospectionViewController(
            selector: { introspectionViewController in
                
                // Search in ancestors
                if let navigationController = introspectionViewController.tabBarController {
                    return navigationController
                }
                
                // Search in siblings
                return Introspect.previousSibling(ofType: UITabBarController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }
    #endif
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (PlatformTextField) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformTextField.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    @available(tvOS, unavailable)
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    public func introspectSwitch(customize: @escaping (PlatformSwitch) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformSwitch.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    @available(tvOS, unavailable)
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (PlatformSlider) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformSlider.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    @available(tvOS, unavailable)
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (PlatformStepper) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformStepper.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    @available(tvOS, unavailable)
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (PlatformDatePicker) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformDatePicker.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (PlatformSegmentedControl) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: PlatformSegmentedControl.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
