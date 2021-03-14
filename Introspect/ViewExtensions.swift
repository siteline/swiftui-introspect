import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
extension View {
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
}

#if canImport(UIKit)
@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        return inject(UIKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds a `UINavigationController` from any view embedded in a `SwiftUI.NavigationView`.
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> ()) -> some View {
        return inject(UIKitIntrospectionViewController(
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
    
    /// Finds the containing `UIViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (UIViewController) -> ()) -> some View {
        return inject(UIKitIntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }

    /// Finds a `UITabBarController` from any SwiftUI view embedded in a `SwiftUI.TabView`
    public func introspectTabBarController(customize: @escaping (UITabBarController) -> ()) -> some View {
        return inject(UIKitIntrospectionViewController(
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
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }
    
    /// Finds a `UITableViewCell` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectTableViewCell(customize: @escaping (UITableViewCell) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }

    /// Finds a `UITextView` from a `SwiftUI.TextEditor`
    public func introspectTextView(customize: @escaping (UITextView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
@available(macOS 10.15.0, *)
extension View {
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: NSView>(
        selector: @escaping (IntrospectionNSView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        return inject(AppKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds a `NSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (NSTableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSTableCellView` from a `SwiftUI.List`, or `SwiftUI.List` child. You can attach this directly to the element inside the list.
    public func introspectTableViewCell(customize: @escaping (NSTableCellView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSiblingContaining, customize: customize)
    }

    /// Finds a `NSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (NSScrollView) -> ()) -> some View {
        if #available(macOS 11.0, *) {
            return introspect(selector: TargetViewSelector.siblingOfTypeOrAncestor, customize: customize)
        } else {
            return introspect(selector: TargetViewSelector.siblingContainingOrAncestor, customize: customize)
        }
    }
    
    /// Finds a `NSTextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (NSTextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSTextView` from a `SwiftUI.TextView`
    public func introspectTextView(customize: @escaping (NSTextView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (NSSlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (NSStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
    
    /// Finds a `NSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.siblingContaining, customize: customize)
    }
}
#endif
