#if os(iOS) || os(macOS)
import SwiftUI

// MARK: SwiftUI.DatePicker { ... }.datePickerStyle(.graphical)

public struct DatePickerWithGraphicalStyleType: IntrospectableViewType {
    public enum Style {
        case graphical
    }
}

extension IntrospectableViewType where Self == DatePickerWithGraphicalStyleType {
    public static func datePicker(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<DatePickerWithGraphicalStyleType, UIDatePicker> {
    @available(*, unavailable, message: ".datePickerStyle(.graphical) isn't available on iOS 13")
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<DatePickerWithGraphicalStyleType, NSDatePicker> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
