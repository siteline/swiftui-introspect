import SwiftUI

// MARK: SwiftUI.List

public struct TextFieldType: ViewType {
    public static let scope: IntrospectionScope = .receiver
}

extension StaticMember where Base == TextFieldType {
    public static var textField: Self { .init(base: .init()) }
}

// MARK: SwiftUI.TextField - iOS

#if canImport(UIKit)
import UIKit

extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == TextFieldType, PlatformView == UITextField {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.TextField - tvOS

#if canImport(UIKit)
import UIKit

extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == TextFieldType, PlatformView == UITextField {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif
