import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

// https://stackoverflow.com/a/71135581/1922543
struct Wrapper<Content: View>: View {
    @State private var size: CGSize?
    @State private var outsideSize: CGSize?
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        GeometryReader { outside in
            Color.clear.preference(
                key: SizePreferenceKey.self,
                value: outside.size
            )
        }
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            outsideSize = newSize
        }
        .frame(width: size?.width, height: size?.height)
        .overlay(
            outsideSize != nil ?
                Representable {
                    content()
                        .background(
                            GeometryReader { inside in
                                Color.clear.preference(
                                    key: SizePreferenceKey.self,
                                    value: inside.size
                                )
                            }
                            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                                size = newSize
                            }
                        )
                        .frame(width: outsideSize!.width, height: outsideSize!.height)
                        .fixedSize()
                        .frame(width: size?.width ?? 0, height: size?.height ?? 0)
                }
                .frame(width: size?.width ?? 0, height: size?.height ?? 0)
            : nil
        )
    }
}

struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct Representable<Content: View>: UIViewRepresentable {
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIView(context: Context) -> UIView {
        let host = UIHostingController(rootView: content())
        let hostView = host.view!
        return hostView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = .systemRed
    }
}

//final class UIHostingController_FB9641883<Content: View>: UIHostingController<Content> {
//    private var heightConstraint: NSLayoutConstraint?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if #available(iOS 15.0, *) {
//            heightConstraint = view.heightAnchor.constraint(equalToConstant: view.intrinsicContentSize.height)
//            NSLayoutConstraint.activate([
//                heightConstraint!,
//            ])
//        }
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        preferredContentSize = view.intrinsicContentSize
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        heightConstraint?.constant = view.intrinsicContentSize.height
//    }
//}

public typealias IntrospectionContainerID = UUID

//struct IntrospectionUIContainerViewController<Content: View>: UIViewControllerRepresentable {
//    let id: IntrospectionContainerID
//    @ViewBuilder
//    let content: Content
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let controller = UIHostingController(rootView: content)
////        controller.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
////        controller.view.setContentHuggingPriority(.required, for: .vertical)
//        controller.view.backgroundColor = .blue
//        controller.view.accessibilityIdentifier = id.uuidString
////        controller.view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
////        controller.view.setContentHuggingPriority(.required, for: .vertical)
////        controller.view.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
////        controller.view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}

struct IntrospectionUIContainerView<Content: View>: UIViewRepresentable {
    let id: IntrospectionContainerID
    @ViewBuilder
    let content: Content

    func makeUIView(context: Context) -> some UIView {
        let host = UIHostingController(rootView: content)
//        if #available(iOS 16, *) {
//            host.sizingOptions = .intrinsicContentSize
//        }
        let hostView = host.view!
        hostView.accessibilityIdentifier = id.uuidString
        hostView.backgroundColor = .blue
        return hostView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}


extension View {
    @ViewBuilder
    public func inject<InjectedView>(_ view: InjectedView) -> some View where
        InjectedView: View & Identifiable,
        InjectedView.ID == IntrospectionContainerID
    {
//        self.tag(123)
//            .accessibility(identifier: view.id.uuidString)
//            .overlay(view.frame(width: 1, height: 1))

        modifier(InjectionView(view: view))
//        self.overlay(view.frame(width: 1, height: 1))
    }
}

struct InjectionView<InjectedView: View & Identifiable>: ViewModifier where InjectedView.ID == IntrospectionContainerID {
    let view: InjectedView

    func body(content: Content) -> some View {
        content.overlay(view.frame(width: 1, height: 1))
//        Wrapper {
//            content.overlay(view.frame(width: 1, height: 1))
//        }
//        .background(Color.red)
    }
}

#if canImport(UIKit)
extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (UIView, IntrospectionContainerID) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds a `UINavigationController` from any view embedded in a `SwiftUI.NavigationView`.
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController, containerID in
                
                // Search in ancestors
                if let navigationController = introspectionViewController.navigationController {
                    return navigationController
                }
                
                // Search in siblings
                return Introspect.previousSibling(
                    containing: UINavigationController.self,
                    from: introspectionViewController,
                    containerID: containerID
                )
            },
            customize: customize
        ))
    }
    
    /// Finds a `UISplitViewController` from  a `SwiftUI.NavigationView` with style `DoubleColumnNavigationViewStyle`.
    public func introspectSplitViewController(customize: @escaping (UISplitViewController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController, containerID in

                // Search in ancestors
                if let splitViewController = introspectionViewController.splitViewController {
                    return splitViewController
                }

                // Search in siblings
                return Introspect.previousSibling(
                    containing: UISplitViewController.self,
                    from: introspectionViewController,
                    containerID: containerID
                )
            },
            customize: customize
        ))
    }
    
    /// Finds the containing `UIViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (UIViewController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { viewController, containerID in viewController.parent },
            customize: customize
        ))
    }

    /// Finds a `UITabBarController` from any SwiftUI view embedded in a `SwiftUI.TabView`
    public func introspectTabBarController(customize: @escaping (UITabBarController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController, containerID in
                
                // Search in ancestors
                if let navigationController = introspectionViewController.tabBarController {
                    return navigationController
                }
                
                // Search in siblings
                return Introspect.previousSibling(
                    ofType: UITabBarController.self,
                    from: introspectionViewController,
                    containerID: containerID
                )
            },
            customize: customize
        ))
    }

    /// Finds a `UISearchController` from a `SwiftUI.View` with a `.searchable` modifier
    @available(iOS 15, *)
    @available(tvOS, unavailable)
    public func introspectSearchController(customize: @escaping (UISearchController) -> ()) -> some View {
        introspectNavigationController { navigationController in
            let navigationBar = navigationController.navigationBar
            if let searchController = navigationBar.topItem?.searchController {
                customize(searchController)
            }
        }
    }
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `UITableViewCell` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectTableViewCell(customize: @escaping (UITableViewCell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UICollectionView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectCollectionView(customize: @escaping (UICollectionView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UICollectionView` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectCollectionViewCell(customize: @escaping (UICollectionViewCell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        if #available(iOS 14, tvOS 14, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }

    /// Finds the horizontal `UIScrollView` from a `SwiftUI.TabBarView` with tab style `SwiftUI.PageTabViewStyle`.
    ///
    /// Customize is called with a `UICollectionView` wrapper, and the horizontal `UIScrollView`.
    @available(iOS 14, tvOS 14, *)
    public func introspectPagedTabView(customize: @escaping (UICollectionView, UIScrollView) -> ()) -> some View {
        if #available(iOS 16, *) {
            return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: { (collectionView: UICollectionView) in
                customize(collectionView, collectionView)
            })
        } else {
            return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: { (collectionView: UICollectionView) in
                for subview in collectionView.subviews {
                    if NSStringFromClass(type(of: subview)).contains("EmbeddedScrollView"), let scrollView = subview as? UIScrollView {
                        customize(collectionView, scrollView)
                        break
                    }
                }
            })
        }
    }

    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContainingOrAncestorOrAncestorChild, customize: customize)
    }

    /// Finds a `UITextView` from a `SwiftUI.TextEditor`
    public func introspectTextView(customize: @escaping (UITextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIColorWell` from a `SwiftUI.ColorPicker`
    @available(iOS 14, *)
    @available(tvOS, unavailable)
    public func introspectColorWell(customize: @escaping (UIColorWell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: NSView>(
        selector: @escaping (IntrospectionNSView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        inject(AppKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }

    /// Finds a `NSSplitViewController` from  a `SwiftUI.NavigationView` with style `DoubleColumnNavigationViewStyle`.
    public func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `NSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (NSTableView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSTableCellView` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectTableViewCell(customize: @escaping (NSTableCellView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (NSScrollView) -> ()) -> some View {
        if #available(macOS 11, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
    
    /// Finds a `NSTextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (NSTextField) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSTextView` from a `SwiftUI.TextView`
    public func introspectTextView(customize: @escaping (NSTextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (NSSlider) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (NSStepper) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSTabView` from a `SwiftUI.TabView`
    public func introspectTabView(customize: @escaping (NSTabView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSButton` from a `SwiftUI.Button`
    public func introspectButton(customize: @escaping (NSButton) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSColorWell` from a `SwiftUI.ColorPicker`
    @available(macOS 11, *)
    public func introspectColorWell(customize: @escaping (NSColorWell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif

#if canImport(MapKit)
import MapKit

extension View {
    /// Finds an `MKMapView` from a `SwiftUI.Map`
    @available(iOS 14, tvOS 14, macOS 11, *)
    public func introspectMapView(customize: @escaping (MKMapView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif
