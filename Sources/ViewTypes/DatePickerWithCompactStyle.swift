import SwiftUI

/// An abstract representation of the `DatePicker` type in SwiftUI, with `.compact` style.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     @State var date = Date()
///
///     var body: some View {
///         DatePicker("Pick a date", selection: $date)
///             .datePickerStyle(.compact)
///             .introspect(.datePicker(style: .compact), on: .iOS(.v14, .v15, .v16, .v17)) {
///                 print(type(of: $0)) // UIDatePicker
///             }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// Not available.
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     @State var date = Date()
///
///     var body: some View {
///         DatePicker("Pick a date", selection: $date)
///             .datePickerStyle(.compact)
///             .introspect(.datePicker(style: .compact), on: .macOS(.v10_15_4, .v11, .v12, .v13, .v14)) {
///                 print(type(of: $0)) // NSDatePicker
///             }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     @State var date = Date()
///
///     var body: some View {
///         DatePicker("Pick a date", selection: $date)
///             .datePickerStyle(.compact)
///             .introspect(.datePicker(style: .compact), on: .visionOS(.v1)) {
///                 print(type(of: $0)) // UIDatePicker
///             }
///     }
/// }
/// ```
public struct DatePickerWithCompactStyleType: IntrospectableViewType {
    public enum Style {
        case compact
    }
}

#if !os(tvOS)
extension IntrospectableViewType where Self == DatePickerWithCompactStyleType {
    public static func datePicker(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<DatePickerWithCompactStyleType, UIDatePicker> {
    @available(*, unavailable, message: ".datePickerStyle(.compact) isn't available on iOS 13")
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension visionOSViewVersion<DatePickerWithCompactStyleType, UIDatePicker> {
    public static let v1 = Self(for: .v1)
}
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<DatePickerWithCompactStyleType, NSDatePicker> {
    @available(*, unavailable, message: ".datePickerStyle(.compact) isn't available on macOS 10.15")
    public static let v10_15 = Self(for: .v10_15)
    public static let v10_15_4 = Self(for: .v10_15_4)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
