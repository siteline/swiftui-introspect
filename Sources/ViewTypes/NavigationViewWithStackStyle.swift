import SwiftUI

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.stack)

public struct NavigationViewWithStackStyleType: IntrospectableViewType {
    public enum Style {
        case stack
    }
}

extension IntrospectableViewType where Self == NavigationViewWithStackStyleType {
    public static func navigationView(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationViewWithStackStyleType, UINavigationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UINavigationController> {
        .default.withAncestorSelector(\.navigationController)
    }
}

extension tvOSViewVersion<NavigationViewWithStackStyleType, UINavigationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UINavigationController> {
        .default.withAncestorSelector(\.navigationController)
    }
}
#endif
