import SwiftUI

// MARK: SwiftUI.List { Cell() }

public struct ListCellType: IntrospectableViewType {
    public var scope: IntrospectionScope { .receiverOrAncestor }
}

extension IntrospectableViewType where Self == ListCellType {
    public static var listCell: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListCellType, UITableViewCell> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListCellType, UICollectionViewCell> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<ListCellType, UITableViewCell> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ListCellType, NSTableCellView> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
