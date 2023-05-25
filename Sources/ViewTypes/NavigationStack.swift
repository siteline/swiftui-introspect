import SwiftUI

// MARK: SwiftUI.NavigationStack

public struct NavigationStackType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == NavigationStackType {
    public static var navigationStack: Self { .init(scope: .receiverOrAncestor) }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationStackType, UINavigationController> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationStackType, UINavigationController> {
    public static let v16 = Self(for: .v16)
}
#endif
