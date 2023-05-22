import SwiftUI

// MARK: SwiftUI.NavigationStack

public struct NavigationStackType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == NavigationStackType {
    public static var navigationStack: Self { .init(scope: .receiverOrAncestor) }
}

// MARK: SwiftUI.NavigationStack - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIViewType == NavigationStackType, PlatformView == UINavigationController {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationStack - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIViewType == NavigationStackType, PlatformView == UINavigationController {
    public static let v16 = Self(for: .v16)
}
#endif
