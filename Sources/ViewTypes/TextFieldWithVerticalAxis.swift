import SwiftUI

// MARK: SwiftUI.TextField(..., axis: .vertical)

public struct TextFieldWithVerticalAxisType: ViewType {
    public static let scope: IntrospectionScope = .receiver
}

extension ViewType where Self == TextFieldWithVerticalAxisType {
    public static var textFieldWithVerticalAxis: Self { .init() }
}

// MARK: SwiftUI.TextField(..., axis: .vertical) - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == TextFieldWithVerticalAxisType, PlatformView == UITextView {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField(..., axis: .vertical) - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == TextFieldWithVerticalAxisType, PlatformView == UITextField {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField(..., axis: .vertical) - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIView == TextFieldWithVerticalAxisType, PlatformView == NSTextField {
    public static let v13 = Self(for: .v13)
}
#endif
