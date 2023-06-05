#if !os(tvOS)
import SwiftUI

// MARK: SwiftUI.Toggle(...).toggleStyle(.switch)

public struct ToggleWithSwitchStyleType: IntrospectableViewType {
    public enum Style {
        case `switch`
    }
}

extension IntrospectableViewType where Self == ToggleWithSwitchStyleType {
    public static func toggle(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ToggleWithSwitchStyleType, UISwitch> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ToggleWithSwitchStyleType, NSSwitch> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
