#if os(iOS) || os(macOS)
import SwiftUI

// MARK: SwiftUI.Table

public struct TableType: IntrospectableViewType {}

extension IntrospectableViewType where Self == TableType {
    public static var table: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TableType, UICollectionView> {
    @available(*, unavailable, message: "Table isn't available on iOS 13")
    public static let v13 = Self(for: .v13)
    @available(*, unavailable, message: "Table isn't available on iOS 14")
    public static let v14 = Self(for: .v14)
    @available(*, unavailable, message: "Table isn't available on iOS 15")
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
extension macOSViewVersion<TableType, NSTableView> {
    @available(*, unavailable, message: "Table isn't available on macOS 10.15")
    public static let v10_15 = Self(for: .v10_15)
    @available(*, unavailable, message: "Table isn't available on macOS 11")
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
