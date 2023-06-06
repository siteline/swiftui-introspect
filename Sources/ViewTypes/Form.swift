#if !os(macOS)
import SwiftUI

// MARK: SwiftUI.Form

public struct FormType: IntrospectableViewType {}

extension IntrospectableViewType where Self == FormType {
    public static var form: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<FormType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<FormType, UICollectionView> {
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<FormType, UITableView> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#endif
#endif
