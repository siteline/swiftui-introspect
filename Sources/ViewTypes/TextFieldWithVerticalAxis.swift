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
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIViewType == TextFieldWithVerticalAxisType, PlatformView == UITextView {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField(..., axis: .vertical) - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIViewType == TextFieldWithVerticalAxisType, PlatformView == UITextField {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField(..., axis: .vertical) - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIViewType == TextFieldWithVerticalAxisType, PlatformView == NSTextField {
    public static let v13 = Self(for: .v13)
}
#endif
