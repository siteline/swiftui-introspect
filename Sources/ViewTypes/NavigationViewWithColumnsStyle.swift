import SwiftUI

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.columns)

public struct NavigationViewWithColumnsStyleType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == NavigationViewWithColumnsStyleType {
    public static var navigationViewWithColumnsStyle: Self { .init(scope: .receiverOrAncestor) }
}

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.columns) - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIViewType == NavigationViewWithColumnsStyleType, PlatformView == UISplitViewController {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.columns) - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIViewType == NavigationViewWithColumnsStyleType, PlatformView == UINavigationController {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationView { ... }.navigationViewStyle(.columns) - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIViewType == NavigationViewWithColumnsStyleType, PlatformView == NSSplitView {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif
