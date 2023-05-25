import SwiftUI

// MARK: SwiftUI.ScrollView

public struct ScrollViewType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == ScrollViewType {
    public static var scrollView: Self { .init(scope: .receiverOrAncestor) }
}

#if canImport(UIKit)
extension iOSViewVersion<ScrollViewType, UIScrollView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<ScrollViewType, UIScrollView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ScrollViewType, NSScrollView> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
