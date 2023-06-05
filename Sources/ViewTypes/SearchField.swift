import SwiftUI

// MARK: SwiftUI.View.searchable(...)

public struct SearchFieldType: IntrospectableViewType {}

extension IntrospectableViewType where Self == SearchFieldType {
    public static var searchField: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<SearchFieldType, UISearchBar> {
    @available(*, unavailable, message: ".searchable isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: ".searchable isn't available on iOS 14")
    public static let v14 = Self.unavailable()
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UISearchBar> {
        .from(UINavigationController.self) {
            $0.viewIfLoaded?.allDescendants.lazy.compactMap { $0 as? UISearchBar }.first
        }
    }
}

extension tvOSViewVersion<SearchFieldType, UISearchBar> {
    @available(*, unavailable, message: ".searchable isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: ".searchable isn't available on tvOS 14")
    public static let v14 = Self.unavailable()
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UISearchBar> {
        .from(UINavigationController.self) {
            $0.viewIfLoaded?.allDescendants.lazy.compactMap { $0 as? UISearchBar }.first
        }
    }
}
#endif
