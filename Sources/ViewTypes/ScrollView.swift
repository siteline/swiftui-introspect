import SwiftUI

// MARK: SwiftUI.ScrollView

public struct ScrollViewType: ViewType {
    public static let scope: IntrospectionScope = .receiverOrAncestor
}

extension ViewType where Self == ScrollViewType {
    public static var scrollView: Self { .init() }
}

// MARK: SwiftUI.ScrollView - iOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == ScrollViewType, PlatformView == UIScrollView {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.ScrollView - tvOS

#if canImport(UIKit)
extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == ScrollViewType, PlatformView == UIScrollView {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
}
#endif

// MARK: SwiftUI.ScrollView - macOS

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIView == ScrollViewType, PlatformView == NSScrollView {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
}
#endif