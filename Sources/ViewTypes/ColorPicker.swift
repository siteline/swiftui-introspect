#if !os(tvOS)
import SwiftUI

// MARK: SwiftUI.ColorPicker

public struct ColorPickerType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ColorPickerType {
    public static var colorPicker: Self { .init() }
}

#if canImport(UIKit)
@available(iOS 14, *)
extension iOSViewVersion<ColorPickerType, UIColorWell> {
    @available(*, unavailable, message: "ColorPicker isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
@available(macOS 11, *)
extension macOSViewVersion<ColorPickerType, NSColorWell> {
    @available(*, unavailable, message: "ColorPicker isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
