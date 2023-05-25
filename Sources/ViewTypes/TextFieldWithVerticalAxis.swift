import SwiftUI

// MARK: SwiftUI.TextField(..., axis: .vertical)

public struct TextFieldWithVerticalAxisType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == TextFieldWithVerticalAxisType {
    public static var textFieldWithVerticalAxis: Self { .init(scope: .receiver) }
}

// MARK: SwiftUI.TextField(..., axis: .vertical) - iOS

#if canImport(UIKit)
extension iOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<TextFieldWithVerticalAxisType, UITextField> {
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldWithVerticalAxisType, NSTextField> {
    public static let v13 = Self(for: .v13)
}
#endif
