import SwiftUI

// MARK: SwiftUI.NavigationStack

public struct NavigationStackType: ViewType {}

extension ViewType where Self == NavigationStackType {
    public static var navigationStack: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationStackType, UINavigationController> {
    @available(*, unavailable, message: "NavigationStack isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationStack isn't available on iOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationStack isn't available on iOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationStackType, UINavigationController> {
    @available(*, unavailable, message: "NavigationStack isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationStack isn't available on tvOS 14")
    public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationStack isn't available on tvOS 15")
    public static let v15 = Self.unavailable()

    public static let v16 = Self(for: .v16)
}
#endif
