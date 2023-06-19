import SwiftUI

// MARK: SwiftUI.DatePicker { ... }.datePickerStyle(.compact)

public struct DatePickerWithCompactStyleType: IntrospectableViewType {
    public enum Style {
        case compact
    }
}

#if os(iOS) || os(macOS)
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
