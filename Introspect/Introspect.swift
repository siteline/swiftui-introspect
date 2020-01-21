import SwiftUI

#if os(iOS)
// MARK: - iOS type aliases
public typealias OSView = UIView
public typealias OSViewController = UIViewController
public typealias OSViewRepresentable = UIViewRepresentable
public typealias OSViewRepresentableContext = UIViewRepresentableContext
public typealias OSViewControllerRepresentable = UIViewControllerRepresentable
public typealias OSViewControllerRepresentableContext = UIViewControllerRepresentableContext

public typealias OSTableView = UITableView
public typealias OSScrollView = UIScrollView
public typealias OSTextField = UITextField
public typealias OSSwitch = UISwitch
public typealias OSSlider = UISlider
public typealias OSStepper = UIStepper
public typealias OSDatePicker = UIDatePicker
public typealias OSSegmentedControl = UISegmentedControl

public typealias IntrospectionUIView = IntrospectionOSView
public typealias IntrospectionUIViewController = IntrospectionOSViewController

extension IntrospectionView: UIViewRepresentable {
    public func makeUIView(context: UIViewRepresentableContext<IntrospectionView<TargetViewType>>) -> IntrospectionUIView {
        return makeOSView(context: context)
    }
    public func updateUIView(_ view: IntrospectionUIView, context: UIViewRepresentableContext<IntrospectionView<TargetViewType>>) {
        updateOSView(view, context: context)
    }
}

extension IntrospectionViewController: UIViewControllerRepresentable {
    public func makeUIViewController(context: UIViewControllerRepresentableContext<IntrospectionViewController>) -> IntrospectionUIViewController {
        return makeOSViewController(context: context)
    }
    public func updateUIViewController(_ viewController: IntrospectionOSViewController, context: UIViewControllerRepresentableContext<IntrospectionViewController>) {
        updateOSViewController(viewController, context: context)
    }
}

private extension UIView {
    func setAccessibilityLabel(_ label: String?) { self.accessibilityLabel = label }
}
private extension UIViewController {
    func setAccessibilityLabel(_ label: String?) { self.accessibilityLabel = label }
}

#elseif os(macOS)
// MARK: - macOS type aliases
public typealias OSView = NSView
public typealias OSViewController = NSViewController
public typealias OSViewRepresentable = NSViewRepresentable
public typealias OSViewRepresentableContext = NSViewRepresentableContext
public typealias OSViewControllerRepresentable = NSViewControllerRepresentable
public typealias OSViewControllerRepresentableContext = NSViewControllerRepresentableContext

public typealias OSTableView = NSTableView
public typealias OSScrollView = NSScrollView
public typealias OSTextField = NSTextField
public typealias OSSwitch = NSSwitch
public typealias OSSlider = NSSlider
public typealias OSStepper = NSStepper
public typealias OSDatePicker = NSDatePicker
public typealias OSSegmentedControl = NSSegmentedControl

public typealias IntrospectionNSView = IntrospectionOSView
public typealias IntrospectionNSViewController = IntrospectionOSViewController

extension IntrospectionView: NSViewRepresentable {
    public func makeNSView(context: NSViewRepresentableContext<IntrospectionView<TargetViewType>>) -> IntrospectionNSView {
        return makeOSView(context: context)
    }
    public func updateNSView(_ view: IntrospectionNSView, context: NSViewRepresentableContext<IntrospectionView<TargetViewType>>) {
        updateOSView(view, context: context)
    }
}

extension IntrospectionViewController: NSViewControllerRepresentable {
    public func makeNSViewController(context: NSViewControllerRepresentableContext<IntrospectionViewController>) -> IntrospectionNSViewController {
        return makeOSViewController(context: context)
    }
    public func updateNSViewController(_ viewController: IntrospectionOSViewController, context: NSViewControllerRepresentableContext<IntrospectionViewController>) {
        updateOSViewController(viewController, context: context)
    }
}

private extension NSViewController {
    func setAccessibilityLabel(_ label: String?) { /* Not supported on macOS */ }
}

#else
let _ = { fatalError("Unsupported os") }()
#endif


// MARK: - Platform independent implemntation

/// Utility methods to inspect the UIKit view hierarchy.
public enum Introspect {
    
    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewType: OSView>(
        ofType type: AnyViewType.Type,
        in root: OSView
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
    public static func findChild<AnyViewControllerType: OSViewController>(
        ofType type: AnyViewControllerType.Type,
        in root: OSViewController
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
    public static func previousSibling<AnyViewType: OSView>(
        containing type: AnyViewType.Type,
        from entry: OSView
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
    public static func previousSibling<AnyViewControllerType: OSViewController>(
        containing type: AnyViewControllerType.Type,
        from entry: OSViewController
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
    public static func previousSibling<AnyViewControllerType: OSViewController>(
        ofType type: AnyViewControllerType.Type,
        from entry: OSViewController
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
    public static func nextSibling<AnyViewType: OSView>(
        containing type: AnyViewType.Type,
        from entry: OSView
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
    public static func findAncestor<AnyViewType: OSView>(ofType type: AnyViewType.Type, from entry: OSView) -> AnyViewType? {
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
    public static func findHostingView(from entry: OSView) -> OSView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("UIHostingView") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
    
    /// Finds the view host of a specific view.
    /// SwiftUI wraps each OSView within a ViewHost, then within a HostingView.
    /// Returns nil if it couldn't find a view host. This should never happen when called with an IntrospectionView.
    public static func findViewHost(from entry: OSView) -> OSView? {
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

/// Introspection OSView that is inserted alongside the target view.
public class IntrospectionOSView: OSView {
    
    required init() {
        super.init(frame: .zero)
        isHidden = true
        
        #if os(iOS) // Disable user interaction for iOS
        isUserInteractionEnabled = false
        #endif
    }
    
    #if os(macOS) // Disable user interaction for macOS
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
/// After `updateOSView` is called, it calls `selector` to find the target view, then `customize` when the target view is found.
public struct IntrospectionView<TargetViewType: OSView> {
    
    /// Method that introspects the view hierarchy to find the target view.
    /// First argument is the introspection view itself, which is contained in a view host alongside the target view.
    let selector: (IntrospectionOSView) -> TargetViewType?
    
    /// User-provided customization method for the target view.
    let customize: (TargetViewType) -> Void
    
    public init(
        selector: @escaping (OSView) -> TargetViewType?,
        customize: @escaping (TargetViewType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeOSView(context: OSViewRepresentableContext<IntrospectionView>) -> IntrospectionOSView {
        let view = IntrospectionOSView()
        view.setAccessibilityLabel("IntrospectionOSView<\(TargetViewType.self)>")
        return view
    }

    /// When `updateOSView` is called after creating the Introspection view, it is not yet in the UIKit hierarchy.
    /// At this point, `introspectionView.superview.superview` is nil and we can't access the target UIKit view.
    /// To workaround this, we wait until the runloop is done inserting the introspection view in the hierarchy, then run the selector.
    /// Finding the target view fails silently if the selector yield no result. This happens when `updateOSView`
    /// gets called when the introspection view gets removed from the hierarchy.
    public func updateOSView(
        _ osView: IntrospectionOSView,
        context: OSViewRepresentableContext<IntrospectionView>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(osView) else {
                return
            }
            self.customize(targetView)
        }
    }
}

/// Introspection OSViewController that is inserted alongside the target view controller.
public class IntrospectionOSViewController: OSViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
        view = IntrospectionOSView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// This is the same logic as IntrospectionView but for view controllers. Please see details above.
public struct IntrospectionViewController<TargetViewControllerType: OSViewController> {
    
    let selector: (IntrospectionOSViewController) -> TargetViewControllerType?
    let customize: (TargetViewControllerType) -> Void
    
    public init(
        selector: @escaping (OSViewController) -> TargetViewControllerType?,
        customize: @escaping (TargetViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customize = customize
    }
    
    public func makeOSViewController(
        context: OSViewControllerRepresentableContext<IntrospectionViewController>
    ) -> IntrospectionOSViewController {
        let viewController = IntrospectionOSViewController()
        viewController.setAccessibilityLabel("IntrospectionOSViewController<\(TargetViewControllerType.self)>")
        viewController.view.setAccessibilityLabel("IntrospectionOSView<\(TargetViewControllerType.self)>")
        return viewController
    }
    
    public func updateOSViewController(
        _ osViewController: IntrospectionOSViewController,
        context: OSViewControllerRepresentableContext<IntrospectionViewController>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(osViewController) else {
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
    
    // TODO: Enable and fix this for macOS
    #if os(iOS)
    /// Finds a `OSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (OSTableView) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in

                // Search in ancestors
                if let tableView = Introspect.findAncestor(ofType: OSTableView.self, from: introspectionView) {
                    return tableView
                }

                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }

                // Search in siblings
                return Introspect.previousSibling(containing: OSTableView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    #endif
    
    /// Finds a `OSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (OSScrollView) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                
                // Search in ancestors
                if let tableView = Introspect.findAncestor(ofType: OSScrollView.self, from: introspectionView) {
                    return tableView
                }
                
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                
                // Search in siblings
                return Introspect.previousSibling(containing: OSScrollView.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    #if os(iOS) // iOS Only
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
    
    /// Finds the containing `OSViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (OSViewController) -> ()) -> some View {
        return inject(IntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }

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
    public func introspectTextField(customize: @escaping (OSTextField) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSTextField.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    
     // TODO: Enable and fix this for macOS
    #if os(iOS)
    /// Finds a `OSSwitch` from a `SwiftUI.Toggle`
    public func introspectSwitch(customize: @escaping (OSSwitch) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSSwitch.self, from: viewHost)
            },
            customize: customize
        ))
    }
    #endif
    
    /// Finds a `OSSlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (OSSlider) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSSlider.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    /// Finds a `OSStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (OSStepper) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSStepper.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    /// Finds a `OSDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (OSDatePicker) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSDatePicker.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    /// Finds a `OSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (OSSegmentedControl) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: OSSegmentedControl.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
