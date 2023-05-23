import SwiftUI

// MARK: SwiftUI.NavigationSplitView

public struct NavigationSplitViewType: ViewType {
    public let scope: IntrospectionScope
}

extension ViewType where Self == NavigationSplitViewType {
    public static var navigationSplitView: Self { .init(scope: .receiverOrAncestor) }
}

// MARK: SwiftUI.NavigationSplitView - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIViewType == NavigationSplitViewType, PlatformView == UISplitViewController {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationSplitView - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIViewType == NavigationSplitViewType, PlatformView == UISplitViewController {
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.NavigationSplitView - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIViewType == NavigationSplitViewType, PlatformView == NSSplitView {
    public static let v13 = Self(for: .v13)
}
#endif
