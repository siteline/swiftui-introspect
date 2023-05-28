#if !os(tvOS)
import SwiftUI

// MARK: SwiftUI.TextEditor

public struct TextEditorType: IntrospectableViewType {}

extension IntrospectableViewType where Self == TextEditorType {
    public static var textEditor: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TextEditorType, UITextView> {
    @available(*, unavailable, message: "TextEditor isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextEditorType, NSTextView> {
    @available(*, unavailable, message: "TextEditor isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
