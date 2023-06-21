import SwiftUI

/// An abstract representation of the `Picker` type in SwiftUI, with `.wheel` style.
///
/// ```swift
/// struct ContentView: View {
///     @State var selection = "1"
///
///     var body: some View {
///         Picker("Pick", selection: $selection) {
///             Text("1").tag("1")
///             Text("2").tag("2")
///             Text("3").tag("3")
///         }
///         .pickerStyle(.wheel)
///         #if os(iOS)
///         .introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // UIPickerView
///         }
///         #endif
///     }
/// }
/// ```
public struct PickerWithWheelStyleType: IntrospectableViewType {
    public enum Style {
        case wheel
    }
}

#if os(iOS)
extension IntrospectableViewType where Self == PickerWithWheelStyleType {
    public static func picker(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<PickerWithWheelStyleType, UIPickerView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#endif
#endif
