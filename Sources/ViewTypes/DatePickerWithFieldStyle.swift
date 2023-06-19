import SwiftUI

// MARK: SwiftUI.DatePicker { ... }.datePickerStyle(.field)

public struct DatePickerWithFieldStyleType: IntrospectableViewType {
    public enum Style {
        case field
    }
}

#if os(macOS)
extension IntrospectableViewType where Self == DatePickerWithFieldStyleType {
    public static func datePicker(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<DatePickerWithFieldStyleType, NSDatePicker> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
