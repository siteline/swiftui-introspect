import SwiftUI

/// An abstract representation of a generic view controller type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         HStack {
///             Image(systemName: "scribble")
///             Text("Some text")
///         }
///         .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // some subclass of UIView
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
///         HStack {
///             Image(systemName: "scribble")
///             Text("Some text")
///         }
///         .introspect(.view, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // some subclass of UIView
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
///         HStack {
///             Image(systemName: "scribble")
///             Text("Some text")
///         }
///         .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) {
///             print(type(of: $0)) // some subclass of NSView
///         }
///     }
/// }
/// ```
///
public struct ViewControllerType: IntrospectableViewType {
    public var scope: IntrospectionScope { [.receiver, .ancestor] }
}

extension IntrospectableViewType where Self == ViewControllerType {
    public static var viewController: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ViewControllerType, UIViewController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<ViewControllerType, UIViewController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#endif
