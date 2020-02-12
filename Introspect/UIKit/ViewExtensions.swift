import SwiftUI
import UIKit

extension View {
    
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        return inject(IntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
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
    
    /// Finds the containing `UIViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (UIViewController) -> ()) -> some View {
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
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (UITableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    public func introspectSwitch(customize: @escaping (UISwitch) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    public func introspectSlider(customize: @escaping (UISlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    public func introspectStepper(customize: @escaping (UIStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
}
