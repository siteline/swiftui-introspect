#if !os(watchOS)
/// An abstract representation of the indeterminate `ProgressView` type in SwiftUI, with the default style.
///
/// This type supports `ProgressView()` and `ProgressView("Loading")` without an explicit style.
/// For determinate `ProgressView(value:)`, use `.progressViewStyle(.linear)` with
/// `.introspect(.progressView(style: .linear), on: ...)`.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         ProgressView()
///             .introspect(.progressView, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26)) {
///                 print(type(of: $0)) // UIActivityIndicatorView
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
///         ProgressView()
///             .introspect(.progressView, on: .tvOS(.v14, .v15, .v16, .v17, .v18, .v26)) {
///                 print(type(of: $0)) // UIActivityIndicatorView
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
///         ProgressView()
///             .introspect(.progressView, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26)) {
///                 print(type(of: $0)) // NSProgressIndicator
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
///         ProgressView()
///             .introspect(.progressView, on: .visionOS(.v1, .v2, .v26)) {
///                 print(type(of: $0)) // UIActivityIndicatorView
///             }
///     }
/// }
/// ```
public struct ProgressViewType: IntrospectableViewType {}

extension IntrospectableViewType where Self == ProgressViewType {
	public static var progressView: Self { .init() }
}

#if canImport(UIKit)
public import UIKit

extension iOSViewVersion<ProgressViewType, UIActivityIndicatorView> {
	@available(*, unavailable, message: "ProgressView isn't available on iOS 13")
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v16 = Self(for: .v16)
	public static let v17 = Self(for: .v17)
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension tvOSViewVersion<ProgressViewType, UIActivityIndicatorView> {
	@available(*, unavailable, message: "ProgressView isn't available on tvOS 13")
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v16 = Self(for: .v16)
	public static let v17 = Self(for: .v17)
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension visionOSViewVersion<ProgressViewType, UIActivityIndicatorView> {
	public static let v1 = Self(for: .v1)
	public static let v2 = Self(for: .v2)
	public static let v26 = Self(for: .v26)
}
#elseif canImport(AppKit)
public import AppKit

extension macOSViewVersion<ProgressViewType, NSProgressIndicator> {
	@available(*, unavailable, message: "ProgressView isn't available on macOS 10.15")
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
