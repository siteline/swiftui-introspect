#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `WebView` type in SwiftUI.
///
/// ### iOS
///
/// TODO
///
/// ### tvOS
///
/// TODO
///
/// ### macOS
///
/// TODO
///
/// ### visionOS
///
/// TODO
public struct WebViewType: IntrospectableViewType {}

#if canImport(WebKit)
import WebKit

extension IntrospectableViewType where Self == WebViewType {
    public static var webView: Self { .init() }
}

extension iOSViewVersion<MapType, WKWebView> {
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

extension tvOSViewVersion<MapType, WKWebView> {
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

extension macOSViewVersion<MapType, WKWebView> {
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

extension visionOSViewVersion<MapType, WKWebView> {
    @available(*, unavailable, message: "WebView isn't available on visionOS 1")
    public static let v1 = Self.unavailable()
    @available(*, unavailable, message: "WebView isn't available on visionOS 2")
    public static let v2 = Self.unavailable()
    public static let v26 = Self(for: .v26)
}
#endif
#endif
