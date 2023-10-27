#if !os(watchOS)
import SwiftUI

/// An abstract representation of a view's window in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Content")
///             .introspect(.window, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
///                 print(type(of: $0)) // UIWindow
///             }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Content")
///             .introspect(.window, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
///                 print(type(of: $0)) // UIWindow
///             }
///     }
/// }
/// ```
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Content")
///             .introspect(.window, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
///                 print(type(of: $0)) // NSWindow
///             }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Content")
///             .introspect(.window, on: .visionOS(.v1)) {
///                 print(type(of: $0)) // UIWindow
///             }
///     }
/// }
/// ```
public struct WindowType: IntrospectableViewType {}

extension IntrospectableViewType where Self == WindowType {
    public static var window: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<WindowType, UIWindow> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIWindow> {
        .from(UIView.self, selector: \.window)
    }
}

extension tvOSViewVersion<WindowType, UIWindow> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIWindow> {
        .from(UIView.self, selector: \.window)
    }
}

extension visionOSViewVersion<WindowType, UIWindow> {
    public static let v1 = Self(for: .v1, selector: selector)

    private static var selector: IntrospectionSelector<UIWindow> {
        .from(UIView.self, selector: \.window)
    }
}
#elseif canImport(AppKit)
extension macOSViewVersion<WindowType, NSWindow> {
    public static let v10_15 = Self(for: .v10_15, selector: selector)
    public static let v11 = Self(for: .v11, selector: selector)
    public static let v12 = Self(for: .v12, selector: selector)
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)

    private static var selector: IntrospectionSelector<NSWindow> {
        .from(NSView.self, selector: \.window)
    }
}
#endif
#endif
