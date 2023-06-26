#if canImport(AVKit)
import AVKit
import SwiftUI

public struct VideoPlayerType: IntrospectableViewType {}

#if !os(tvOS)
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
#elseif canImport(AppKit)
//extension macOSViewVersion<VideoPlayerType, NSSwitch> {
//    public static let v10_15 = Self(for: .v10_15)
//    public static let v11 = Self(for: .v11)
//    public static let v12 = Self(for: .v12)
//    public static let v13 = Self(for: .v13)
//    public static let v14 = Self(for: .v14)
//}
#endif
#endif
#endif
