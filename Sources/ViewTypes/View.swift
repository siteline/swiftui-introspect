#if !os(watchOS)
import SwiftUI

/// An abstract representation of a generic SwiftUI view type.
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
///         .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
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
///         .introspect(.view, on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
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
///         .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
///             print(type(of: $0)) // some subclass of NSView
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
///         HStack {
///             Image(systemName: "scribble")
///             Text("Some text")
///         }
///         .introspect(.view, on: .visionOS(.v1, .v2)) {
///             print(type(of: $0)) // some subclass of UIView
///         }
///     }
/// }
/// ```
public struct ViewType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ViewType {
    public static var view: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ViewType, UIView> {
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension tvOSViewVersion<ViewType, UIView> {
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension visionOSViewVersion<ViewType, UIView> {
    @MainActor public static let v1 = Self(for: .v1)
    @MainActor public static let v2 = Self(for: .v2)
}
#elseif canImport(AppKit)
extension macOSViewVersion<ViewType, NSView> {
    @MainActor public static let v10_15 = Self(for: .v10_15)
    @MainActor public static let v11 = Self(for: .v11)
    @MainActor public static let v12 = Self(for: .v12)
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
}
#endif
#endif
