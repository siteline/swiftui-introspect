import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension View {
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        overlay(view.frame(width: 0, height: 0))
    }
}

#if canImport(UIKit)
extension View {

    /// Finds a `TargetView` from a `SwiftUI.View`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        inject(UIKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }

    /// Finds a `UINavigationController` from any view embedded in a `SwiftUI.NavigationView`.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
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
    
    /// Finds a `UISplitViewController` from  a `SwiftUI.NavigationView` with style `DoubleColumnNavigationViewStyle`.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSplitViewController(customize: @escaping (UISplitViewController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController in

                // Search in ancestors
                if let splitViewController = introspectionViewController.splitViewController {
                    return splitViewController
                }

                // Search in siblings
                return Introspect.previousSibling(containing: UISplitViewController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }
    
    /// Finds the containing `UIViewController` of a SwiftUI view.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectViewController(customize: @escaping (UIViewController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }

    /// Finds a `UITabBarController` from any SwiftUI view embedded in a `SwiftUI.TabView`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTabBarController(customize: @escaping (UITabBarController) -> ()) -> some View {
        inject(UIKitIntrospectionViewController(
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

    /// Finds a `UISearchController` from a `SwiftUI.View` with a `.searchable` modifier
    @available(iOS 15, *)
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSearchController(customize: @escaping (UISearchController) -> ()) -> some View {
        introspectNavigationController { navigationController in
            let navigationBar = navigationController.navigationBar
            if let searchController = navigationBar.topItem?.searchController {
                customize(searchController)
            }
        }
    }
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `UITableViewCell` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTableViewCell(customize: @escaping (UITableViewCell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UICollectionView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectCollectionView(customize: @escaping (UICollectionView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UICollectionView` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectCollectionViewCell(customize: @escaping (UICollectionViewCell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        if #available(iOS 14, tvOS 14, *) {
            return introspect(selector: TargetViewSelector.siblingOrAncestorOrSiblingContainingOrAncestorChild, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }

    /// Finds the horizontal `UIScrollView` from a `SwiftUI.TabBarView` with tab style `SwiftUI.PageTabViewStyle`.
    ///
    /// Customize is called with a `UICollectionView` wrapper, and the horizontal `UIScrollView`.
    @available(iOS 14, tvOS 14, *)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
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
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContainingOrAncestorOrAncestorChild, customize: customize)
    }

    /// Finds a `UITextView` from a `SwiftUI.TextEditor`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTextView(customize: @escaping (UITextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIColorWell` from a `SwiftUI.ColorPicker`
    #if os(iOS)
    @available(iOS 14, *)
    @available(tvOS, unavailable)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectColorWell(customize: @escaping (UIColorWell) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    #endif
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
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
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `NSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTableView(customize: @escaping (NSTableView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSTableCellView` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTableViewCell(customize: @escaping (NSTableCellView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectScrollView(customize: @escaping (NSScrollView) -> ()) -> some View {
        if #available(macOS 11, *) {
            return introspect(selector: TargetViewSelector.siblingOrAncestorOrSiblingContainingOrAncestorChild, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
    
    /// Finds a `NSTextField` from a `SwiftUI.TextField`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTextField(customize: @escaping (NSTextField) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSTextView` from a `SwiftUI.TextView`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTextView(customize: @escaping (NSTextView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSlider` from a `SwiftUI.Slider`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSlider(customize: @escaping (NSSlider) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSStepper` from a `SwiftUI.Stepper`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectStepper(customize: @escaping (NSStepper) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSDatePicker` from a `SwiftUI.DatePicker`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSTabView` from a `SwiftUI.TabView`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectTabView(customize: @escaping (NSTabView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSButton` from a `SwiftUI.Button`
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectButton(customize: @escaping (NSButton) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSColorWell` from a `SwiftUI.ColorPicker`
    @available(macOS 11, *)
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
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
    @available(*, deprecated, message: "The Introspect module is deprecated and will be obsoleted later this year. Please switch over to the new and improved SwiftUIIntrospect module. More info: https://github.com/siteline/swiftui-introspect#readme")
    public func introspectMapView(customize: @escaping (MKMapView) -> ()) -> some View {
        introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif
