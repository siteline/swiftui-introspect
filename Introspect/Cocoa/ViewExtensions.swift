import SwiftUI
import Cocoa

enum TargetViewSelector {
    public static func sibling<TargetView: NSView>(introspectionView: IntrospectionNSView) -> TargetView? {
        guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
            return nil
        }
        return Introspect.previousSibling(containing: TargetView.self, from: viewHost)
    }
    
    public static func ancestorOrSibling<TargetView: NSView>(introspectionView: IntrospectionNSView) -> TargetView? {
        if let tableView = Introspect.findAncestor(ofType: TargetView.self, from: introspectionView) {
            return tableView
        }
        return sibling(introspectionView: introspectionView)
    }
}

extension View {
    
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
    
    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: NSView>(
        selector: @escaping (IntrospectionNSView) -> TargetView?,
        customize: @escaping (TargetView) -> ()
    ) -> some View {
        return inject(IntrospectionView(
            selector: selector,
            customize: customize
        ))
    }
    
    /// Finds the containing `NSViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (NSViewController) -> ()) -> some View {
        return inject(IntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }
    
    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (NSTableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (NSScrollView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (NSTextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    public func introspectSwitch(customize: @escaping (NSSwitch) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (NSSlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (NSStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
}
