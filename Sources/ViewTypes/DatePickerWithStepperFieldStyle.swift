import SwiftUI

/// An abstract representation of the `DatePicker` type in SwiftUI, with `.stepperField` style.
///
/// ```swift
/// struct ContentView: View {
///     @State var date = Date()
///
///     var body: some View {
///         DatePicker("Pick a date", selection: $date)
///             .datePickerStyle(.stepperField)
///             #if os(macOS)
///             .introspect(.datePicker(style: .stepperField), on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
///                 print(type(of: $0)) // NSDatePicker
///             }
///             #endif
///     }
/// }
/// ```
public struct DatePickerWithStepperFieldStyleType: IntrospectableViewType {
    public enum Style {
        case stepperField
    }
}

#if os(macOS)
extension IntrospectableViewType where Self == DatePickerWithStepperFieldStyleType {
    public static func datePicker(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<DatePickerWithStepperFieldStyleType, NSDatePicker> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
