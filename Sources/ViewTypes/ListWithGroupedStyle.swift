#if os(iOS) || os(tvOS)
import SwiftUI

// MARK: SwiftUI.List { ... }.listStyle(.grouped)

public struct ListWithGroupedStyleType: IntrospectableViewType {
    public enum Style {
        case grouped
    }
}

extension IntrospectableViewType where Self == ListWithGroupedStyleType {
    public static func list(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListWithGroupedStyleType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListWithGroupedStyleType, UICollectionView> {
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<ListWithGroupedStyleType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#endif
#endif
