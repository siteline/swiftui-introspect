import SwiftUI

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.stack)

public struct NavigationViewWithStackStyleType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == NavigationViewWithStackStyleType {
    public static var navigationViewWithStackStyle: Self { .init(scope: .receiverOrAncestor) }
}

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.stack) - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIViewType == NavigationViewWithStackStyleType, PlatformView == UINavigationController {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.stack) - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIViewType == NavigationViewWithStackStyleType, PlatformView == UINavigationController {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif
