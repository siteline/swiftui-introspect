import SwiftUI

// MARK: SwiftUI.NavigationSplitView

public struct NavigationSplitViewType: IntrospectableViewType {}

extension IntrospectableViewType where Self == NavigationSplitViewType {
    public static var navigationSplitView: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationSplitViewType, UISplitViewController> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16, selector: selector)

    private static var selector: IntrospectionSelector<UISplitViewController> {
        .default.withAncestorSelector(\.splitViewController)
    }
}

extension tvOSViewVersion<NavigationSplitViewType, UINavigationController> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16, selector: selector)

    private static var selector: IntrospectionSelector<UINavigationController> {
        .default.withAncestorSelector(\.navigationController)
    }
}
#elseif canImport(AppKit)
extension macOSViewVersion<NavigationSplitViewType, NSSplitView> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 11")
    public static let v11 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 12")
    public static let v12 = Self.unavailable()

    public static let v13 = Self(for: .v13)
}
#endif
