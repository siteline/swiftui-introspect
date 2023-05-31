#if os(iOS) || os(macOS)
import SwiftUI

// MARK: SwiftUI.List { ... }.listStyle(.inset)

public struct ListWithSidebarStyleType: IntrospectableViewType {
    public enum Style {
        case sidebar
    }
}

extension IntrospectableViewType where Self == ListWithSidebarStyleType {
    public static func list(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListWithSidebarStyleType, UITableView> {
    @available(*, unavailable, message: ".listStyle(.sidebar) isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListWithSidebarStyleType, UICollectionView> {
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ListWithSidebarStyleType, NSTableView> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
#endif
