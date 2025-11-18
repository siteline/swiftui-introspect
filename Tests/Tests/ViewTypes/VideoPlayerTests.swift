#if canImport(AVKit)
import AVKit
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct VideoPlayerTests {
	#if canImport(UIKit)
	typealias PlatformVideoPlayer = AVPlayerViewController
	#elseif canImport(AppKit)
	typealias PlatformVideoPlayer = AVPlayerView
	#endif

	@Test func introspect() async throws {
		let videoURL1 = try #require(URL(string: "https://bit.ly/swswift#1"))
		let videoURL2 = try #require(URL(string: "https://bit.ly/swswift#2"))
		let videoURL3 = try #require(URL(string: "https://bit.ly/swswift#3"))

		let (entity1, entity2, entity3) = try await introspection(of: PlatformVideoPlayer.self) { spy1, spy2, spy3 in
			VStack {
				VideoPlayer(player: AVPlayer(url: videoURL1))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				VideoPlayer(player: AVPlayer(url: videoURL2))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				VideoPlayer(player: AVPlayer(url: videoURL3))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#expect((entity1.player?.currentItem?.asset as? AVURLAsset)?.url == videoURL1)
		#expect((entity2.player?.currentItem?.asset as? AVURLAsset)?.url == videoURL2)
		#expect((entity3.player?.currentItem?.asset as? AVURLAsset)?.url == videoURL3)
	}
}
#endif
