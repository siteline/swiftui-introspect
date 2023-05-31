#if os(iOS)
import SwiftUI

// MARK: SwiftUI.List { ... }.listStyle(.insetGrouped)

public struct ListWithInsetGroupedStyleType: IntrospectableViewType {
    public enum Style {
        case insetGrouped
    }
}

extension IntrospectableViewType where Self == ListWithInsetGroupedStyleType {
    public static func list(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListWithInsetGroupedStyleType, UITableView> {
    @available(*, unavailable, message: ".listStyle(.insetGrouped) isn't available on iOS 13")
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListWithInsetGroupedStyleType, UICollectionView> {
    public static let v16 = Self(for: .v16)
}
#endif
#endif
