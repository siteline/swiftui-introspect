import SwiftUI

// MARK: SwiftUI.TextField

public struct TextFieldType: ViewType {
    public static let scope: IntrospectionScope = .receiver
}

extension StaticMember where Base == TextFieldType {
    public static var textField: Self { .init(base: .init()) }
}

// MARK: SwiftUI.TextField - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == TextFieldType, PlatformView == UITextField {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == TextFieldType, PlatformView == UITextField {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIView == TextFieldType, PlatformView == NSTextField {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
