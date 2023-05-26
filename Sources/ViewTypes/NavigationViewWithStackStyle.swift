import SwiftUI

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.stack)

public struct NavigationViewWithStackStyleType: ViewType {}

extension ViewType where Self == NavigationViewWithStackStyleType {
    public static var navigationViewWithStackStyle: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationViewWithStackStyleType, UINavigationController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationViewWithStackStyleType, UINavigationController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif
