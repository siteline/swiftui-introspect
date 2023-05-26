import SwiftUI

// MARK: SwiftUI.NavigationStack

public struct NavigationStackType: ViewType {}

extension ViewType where Self == NavigationStackType {
    public static var navigationStack: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationStackType, UINavigationController> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationStackType, UINavigationController> {
    public static let v16 = Self(for: .v16)
}
#endif
