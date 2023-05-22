import SwiftUI

// MARK: SwiftUI.NavigationStack

public struct NavigationStackType: ViewType {
    public static let scope: IntrospectionScope = .receiverOrAncestor
}

extension ViewType where Self == NavigationStackType {
    public static var navigationStack: Self { .init() }
}

// MARK: SwiftUI.NavigationStack - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == NavigationStackType, PlatformView == UINavigationController {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationStack - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == NavigationStackType, PlatformView == UINavigationController {
    public static let v16 = Self(for: .v16)
}
#endif
