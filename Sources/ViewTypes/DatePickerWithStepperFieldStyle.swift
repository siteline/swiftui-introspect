#if os(macOS)
import SwiftUI

// MARK: SwiftUI.DatePicker { ... }.datePickerStyle(.stepperField)

public struct DatePickerWithStepperFieldStyleType: IntrospectableViewType {
    public enum Style {
        case stepperField
    }
}

extension IntrospectableViewType where Self == DatePickerWithStepperFieldStyleType {
    public static func datePicker(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<DatePickerWithStepperFieldStyleType, NSDatePicker> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
