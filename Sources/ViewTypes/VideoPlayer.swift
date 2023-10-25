#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `VideoPlayer` type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
///             .introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17)) {
///                 print(type(of: $0)) // AVPlayerViewController
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
///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
///             .introspect(.videoPlayer, on: .tvOS(.v14, .v15, .v16, .v17)) {
///                 print(type(of: $0)) // AVPlayerViewController
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
///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
///             .introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14)) {
///                 print(type(of: $0)) // AVPlayerView
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
///         VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
///             .introspect(.videoPlayer, on: .visionOS(.v1)) {
///                 print(type(of: $0)) // AVPlayerViewController
///             }
///     }
/// }
/// ```
public struct VideoPlayerType: IntrospectableViewType {}

#if canImport(AVKit)
import AVKit

extension IntrospectableViewType where Self == VideoPlayerType {
    public static var videoPlayer: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<VideoPlayerType, AVPlayerViewController> {
    @available(*, unavailable, message: "VideoPlayer isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<VideoPlayerType, AVPlayerViewController> {
    @available(*, unavailable, message: "VideoPlayer isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension visionOSViewVersion<VideoPlayerType, AVPlayerViewController> {
    public static let v1 = Self(for: .v1)
}
#elseif canImport(AppKit)
extension macOSViewVersion<VideoPlayerType, AVPlayerView> {
    @available(*, unavailable, message: "VideoPlayer isn't available on macOS 10.15")
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
#endif
#endif
