#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `NavigationSplitView` type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationSplitView {
///             Text("Root")
///         } detail: {
///             Text("Detail")
///         }
///         .introspect(.navigationSplitView, on: .iOS(.v16, .v17, .v18)) {
///             print(type(of: $0)) // UISplitViewController
///         }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationSplitView {
///             Text("Root")
///         } detail: {
///             Text("Detail")
///         }
///         .introspect(.navigationSplitView, on: .tvOS(.v16, .v17, .v18)) {
///             print(type(of: $0)) // UINavigationController
///         }
///     }
/// }
/// ```
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationSplitView {
///             Text("Root")
///         } detail: {
///             Text("Detail")
///         }
///         .introspect(.navigationSplitView, on: .macOS(.v13, .v14, .v15)) {
///             print(type(of: $0)) // NSSplitView
///         }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationSplitView {
///             Text("Root")
///         } detail: {
///             Text("Detail")
///         }
///         .introspect(.navigationSplitView, on: .visionOS(.v1, .v2)) {
///             print(type(of: $0)) // UISplitViewController
///         }
///     }
/// }
/// ```
public struct NavigationSplitViewType: IntrospectableViewType {}

extension IntrospectableViewType where Self == NavigationSplitViewType {
    @MainActor public static var navigationSplitView: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationSplitViewType, UISplitViewController> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 13")
    @MainActor public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 14")
    @MainActor public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on iOS 15")
    @MainActor public static let v15 = Self.unavailable()

    @MainActor public static let v16 = Self(for: .v16, selector: selector)
    @MainActor public static let v17 = Self(for: .v17, selector: selector)
    @MainActor public static let v18 = Self(for: .v18, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UISplitViewController> {
        .default.withAncestorSelector(\.splitViewController)
    }
}

extension tvOSViewVersion<NavigationSplitViewType, UINavigationController> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 13")
    @MainActor public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 14")
    @MainActor public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on tvOS 15")
    @MainActor public static let v15 = Self.unavailable()

    @MainActor public static let v16 = Self(for: .v16, selector: selector)
    @MainActor public static let v17 = Self(for: .v17, selector: selector)
    @MainActor public static let v18 = Self(for: .v18, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UINavigationController> {
        .default.withAncestorSelector(\.navigationController)
    }
}

extension visionOSViewVersion<NavigationSplitViewType, UISplitViewController> {
    @MainActor public static let v1 = Self(for: .v1, selector: selector)
    @MainActor public static let v2 = Self(for: .v2, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UISplitViewController> {
        .default.withAncestorSelector(\.splitViewController)
    }
}
#elseif canImport(AppKit)
extension macOSViewVersion<NavigationSplitViewType, NSSplitView> {
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 10.15")
    @MainActor public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 11")
    @MainActor public static let v11 = Self.unavailable()
    @available(*, unavailable, message: "NavigationSplitView isn't available on macOS 12")
    @MainActor public static let v12 = Self.unavailable()

    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
}
#endif
#endif
