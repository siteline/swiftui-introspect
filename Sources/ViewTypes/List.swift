import SwiftUI

// MARK: SwiftUI.List

public struct ListType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ListType {
    public static var list: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListType, UICollectionView> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<ListType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ListType, NSTableView> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
