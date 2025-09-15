#if !os(watchOS)
/// An abstract representation of a generic SwiftUI view type.
///
/// Note: prior to iOS 26, primitive views like `Text`, `Image`, `Button`, and layout
/// stacks were drawn inside a subclass of `UIView` called `_UIGraphicsView` which was
/// introspectable via `.introspect(.view)`, however starting iOS 26 this is no longer the
/// case and all SwiftUI primitives seem to somehow be drawn without an underlying
/// `UIView` vessel.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ExampleUIViewRepresentable()
///             .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
///                 print(type(of: $0)) // some subclass of UIView
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
///         ExampleUIViewRepresentable()
///             .introspect(.view, on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
///                 print(type(of: $0)) // some subclass of UIView
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
///         ExampleUIViewRepresentable()
///             .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) {
///                 print(type(of: $0)) // some subclass of NSView
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
///         ExampleUIViewRepresentable()
///             .introspect(.view, on: .visionOS(.v1, .v2, .v26)) {
///                 print(type(of: $0)) // some subclass of UIView
///             }
///     }
/// }
/// ```
public struct ViewType: IntrospectableViewType {}

// TODO: I think if Swift ever gets parameterized extensions we could introduce subtypes like:
//
// public struct ViewType<PlatformViewType: PlatformView>: IntrospectableViewType {}
//
// extension <V: PlatformView> IntrospectableViewType where Self == ViewType<V> {
//     public static func view<V>(ofType: V.Type) -> Self { ... }
// }

extension IntrospectableViewType where Self == ViewType {
	public static var view: Self { .init() }
}

#if canImport(UIKit)
public import UIKit

extension iOSViewVersion<ViewType, UIView> {
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v16 = Self(for: .v16)
	public static let v17 = Self(for: .v17)
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension tvOSViewVersion<ViewType, UIView> {
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v16 = Self(for: .v16)
	public static let v17 = Self(for: .v17)
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension visionOSViewVersion<ViewType, UIView> {
	public static let v1 = Self(for: .v1)
	public static let v2 = Self(for: .v2)
	public static let v26 = Self(for: .v26)
}
#elseif canImport(AppKit)
public import AppKit

extension macOSViewVersion<ViewType, NSView> {
	public static let v10_15 = Self(for: .v10_15)
	public static let v11 = Self(for: .v11)
	public static let v12 = Self(for: .v12)
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v26 = Self(for: .v26)
}
#endif
#endif
