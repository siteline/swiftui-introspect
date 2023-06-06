#if os(macOS)
import SwiftUI

// MARK: SwiftUI.Toggle(...).toggleStyle(.button)

public struct ToggleWithButtonStyleType: IntrospectableViewType {
    public enum Style {
        case button
    }
}

extension IntrospectableViewType where Self == ToggleWithButtonStyleType {
    public static func toggle(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<ToggleWithButtonStyleType, NSButton> {
    @available(*, unavailable, message: ".toggleStyle(.button) isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: ".toggleStyle(.button) isn't available on macOS 11")
    public static let v11 = Self.unavailable()
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
