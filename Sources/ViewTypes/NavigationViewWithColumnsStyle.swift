#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `NavigationView` type in SwiftUI, with `.columns` style.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationView {
///             Text("Root")
///         }
///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
///         .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
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
///         NavigationView {
///             Text("Root")
///         }
///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
///         .introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
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
///         NavigationView {
///             Text("Root")
///         }
///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
///         .introspect(.navigationView(style: .columns), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
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
///         NavigationView {
///             Text("Root")
///         }
///         .navigationViewStyle(DoubleColumnNavigationViewStyle())
///         .introspect(.navigationView(style: .columns), on: .visionOS(.v1, .v2)) {
///             print(type(of: $0)) // UISplitViewController
///         }
///     }
/// }
/// ```
public struct NavigationViewWithColumnsStyleType: IntrospectableViewType {
    public enum Style: Sendable {
        case columns
    }
}

extension IntrospectableViewType where Self == NavigationViewWithColumnsStyleType {
    @MainActor public static func navigationView(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<NavigationViewWithColumnsStyleType, UISplitViewController> {
    @MainActor public static let v13 = Self(for: .v13, selector: selector)
    @MainActor public static let v14 = Self(for: .v14, selector: selector)
    @MainActor public static let v15 = Self(for: .v15, selector: selector)
    @MainActor public static let v16 = Self(for: .v16, selector: selector)
    @MainActor public static let v17 = Self(for: .v17, selector: selector)
    @MainActor public static let v18 = Self(for: .v18, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UISplitViewController> {
        .default.withAncestorSelector(\.splitViewController)
    }
}

extension tvOSViewVersion<NavigationViewWithColumnsStyleType, UINavigationController> {
    @MainActor public static let v13 = Self(for: .v13, selector: selector)
    @MainActor public static let v14 = Self(for: .v14, selector: selector)
    @MainActor public static let v15 = Self(for: .v15, selector: selector)
    @MainActor public static let v16 = Self(for: .v16, selector: selector)
    @MainActor public static let v17 = Self(for: .v17, selector: selector)
    @MainActor public static let v18 = Self(for: .v18, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UINavigationController> {
        .default.withAncestorSelector(\.navigationController)
    }
}

extension visionOSViewVersion<NavigationViewWithColumnsStyleType, UISplitViewController> {
    @MainActor public static let v1 = Self(for: .v1, selector: selector)
    @MainActor public static let v2 = Self(for: .v2, selector: selector)

    @MainActor private static var selector: IntrospectionSelector<UISplitViewController> {
        .default.withAncestorSelector(\.splitViewController)
    }
}
#elseif canImport(AppKit)
extension macOSViewVersion<NavigationViewWithColumnsStyleType, NSSplitView> {
    @MainActor public static let v10_15 = Self(for: .v10_15)
    @MainActor public static let v11 = Self(for: .v11)
    @MainActor public static let v12 = Self(for: .v12)
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
}
#endif
#endif
