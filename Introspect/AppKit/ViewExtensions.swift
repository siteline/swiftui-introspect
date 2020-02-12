import SwiftUI
import AppKit

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
    
    /// Finds a `NSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (NSTableView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `NSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (NSScrollView) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }
    
    /// Finds a `NSTextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (NSTextField) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `NSSlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (NSSlider) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `NSStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (NSStepper) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `NSDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
    
    /// Finds a `NSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> ()) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
}
