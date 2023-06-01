import SwiftUI

// MARK: SwiftUI.Picker { ... }.pickerStyle(.segmented)

public struct PickerWithSegmentedStyleType: IntrospectableViewType {
    public enum Style {
        case segmented
    }
}

extension IntrospectableViewType where Self == PickerWithSegmentedStyleType {
    public static func picker(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<PickerWithSegmentedStyleType, UISegmentedControl> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<PickerWithSegmentedStyleType, UISegmentedControl> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<PickerWithSegmentedStyleType, NSSegmentedControl> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
