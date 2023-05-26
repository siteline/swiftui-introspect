import SwiftUI

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.columns)

public struct NavigationViewWithColumnsStyleType: ViewType {}

extension ViewType where Self == NavigationViewWithColumnsStyleType {
    public static var navigationViewWithColumnsStyle: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationViewWithColumnsStyleType, UISplitViewController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationViewWithColumnsStyleType, UINavigationController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<NavigationViewWithColumnsStyleType, NSSplitView> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
