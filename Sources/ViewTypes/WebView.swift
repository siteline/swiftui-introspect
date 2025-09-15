#if !os(watchOS)
/// An abstract representation of the `WebView` type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     @State var url = URL(string: "https://example.com")!
///
///     var body: some View {
///         WebView(url: url)
///             .introspect(.webView, on: .iOS(.v26)) {
///                 print(type(of: $0)) // WKWebView
///             }
///         }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// struct ContentView: View {
///     @State var url = URL(string: "https://example.com")!
///
///     var body: some View {
///         WebView(url: url)
///             .introspect(.webView, on: .tvOS(.v26)) {
///                 print(type(of: $0)) // WKWebView
///             }
///         }
///     }
/// }
/// ```
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     @State var url = URL(string: "https://example.com")!
///
///     var body: some View {
///         WebView(url: url)
///             .introspect(.webView, on: .macOS(.v26)) {
///                 print(type(of: $0)) // WKWebView
///             }
///         }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     @State var url = URL(string: "https://example.com")!
///
///     var body: some View {
///         WebView(url: url)
///             .introspect(.webView, on: .visionOS(.v26)) {
///                 print(type(of: $0)) // WKWebView
///             }
///         }
///     }
/// }
/// ```
public struct WebViewType: IntrospectableViewType {}

#if canImport(WebKit)
public import WebKit

extension IntrospectableViewType where Self == WebViewType {
	public static var webView: Self { .init() }
}

extension iOSViewVersion<WebViewType, WKWebView> {
	@available(*, unavailable, message: "WebView isn't available on iOS 13")
	public static let v13 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on iOS 14")
	public static let v14 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on iOS 15")
	public static let v15 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on iOS 16")
	public static let v16 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on iOS 17")
	public static let v17 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on iOS 18")
	public static let v18 = Self.unavailable()

	public static let v26 = Self(for: .v26)
}

extension tvOSViewVersion<WebViewType, WKWebView> {
	@available(*, unavailable, message: "WebView isn't available on tvOS 13")
	public static let v13 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on tvOS 14")
	public static let v14 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on tvOS 15")
	public static let v15 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on tvOS 16")
	public static let v16 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on tvOS 17")
	public static let v17 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on tvOS 18")
	public static let v18 = Self.unavailable()

	public static let v26 = Self(for: .v26)
}

extension macOSViewVersion<WebViewType, WKWebView> {
	@available(*, unavailable, message: "WebView isn't available on macOS 10.15")
	public static let v10_15 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on macOS 11")
	public static let v11 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on macOS 12")
	public static let v12 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on macOS 13")
	public static let v13 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on macOS 14")
	public static let v14 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on macOS 15")
	public static let v15 = Self.unavailable()

	public static let v26 = Self(for: .v26)
}

extension visionOSViewVersion<WebViewType, WKWebView> {
	@available(*, unavailable, message: "WebView isn't available on visionOS 1")
	public static let v1 = Self.unavailable()
	@available(*, unavailable, message: "WebView isn't available on visionOS 2")
	public static let v2 = Self.unavailable()

	public static let v26 = Self(for: .v26)
}
#endif
#endif
