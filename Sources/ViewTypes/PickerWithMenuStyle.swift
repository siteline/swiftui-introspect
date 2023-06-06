#if os(macOS)
import SwiftUI

// MARK: SwiftUI.Picker { ... }.pickerStyle(.menu)

public struct PickerWithMenuStyleType: IntrospectableViewType {
    public enum Style {
        case menu
    }
}

extension IntrospectableViewType where Self == PickerWithMenuStyleType {
    public static func picker(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<PickerWithMenuStyleType, NSPopUpButton> {
    @available(*, unavailable, message: ".pickerStyle(.menu) isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
