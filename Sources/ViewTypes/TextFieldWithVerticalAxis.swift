import SwiftUI

// MARK: SwiftUI.TextField(..., axis: .vertical)

public struct TextFieldWithVerticalAxisType: ViewType {}

extension ViewType where Self == TextFieldWithVerticalAxisType {
    public static var textFieldWithVerticalAxis: Self { .init() }
}

// MARK: SwiftUI.TextField(..., axis: .vertical) - iOS

#if canImport(UIKit)
extension iOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<TextFieldWithVerticalAxisType, UITextField> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldWithVerticalAxisType, NSTextField> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 11")
    public static let v11 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 12")
    public static let v12 = Self.unavailable()

    public static let v13 = Self(for: .v13)
}
#endif
