#if os(macOS)
import SwiftUI

// MARK: SwiftUI.Button

public struct ButtonType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ButtonType {
    public static var button: Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<ButtonType, NSButton> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
