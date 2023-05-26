import SwiftUI

// MARK: SwiftUI.NavigationSplitView

public struct NavigationSplitViewType: ViewType {}

extension ViewType where Self == NavigationSplitViewType {
    public static var navigationSplitView: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationSplitViewType, UISplitViewController> {
    public static let v16 = Self(for: .v16)
}

extension tvOSViewVersion<NavigationSplitViewType, UINavigationController> {
    public static let v16 = Self(for: .v16)
}
#elseif canImport(AppKit)
extension macOSViewVersion<NavigationSplitViewType, NSSplitView> {
    public static let v13 = Self(for: .v13)
}
#endif
