#if !os(macOS)
import SwiftUI

// MARK: SwiftUI.TabView {}.tabViewStyle(.page)

public struct TabViewWithPageStyleType: IntrospectableViewType {}

extension IntrospectableViewType where Self == TabViewWithPageStyleType {
    public static var tabViewWithPageStyle: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<TabViewWithPageStyleType, UICollectionView> {
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif
#endif
