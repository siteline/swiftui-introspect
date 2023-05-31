#if !os(macOS)
import SwiftUI

// MARK: SwiftUI.TabView {}.tabViewStyle(.page)

public struct TabViewWithPageStyleType: IntrospectableViewType {
    public enum Style {
        case page
    }
}

extension IntrospectableViewType where Self == TabViewWithPageStyleType {
    public static func tabView(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
    @available(*, unavailable, message: "TabView {}.tabViewStyle(.page) isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
    @available(*, unavailable, message: "TabView {}.tabViewStyle(.page) isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif
#endif
