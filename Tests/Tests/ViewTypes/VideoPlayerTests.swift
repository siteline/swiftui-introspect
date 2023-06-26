#if canImport(AVKit)
import AVKit
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 14, macOS 11, *)
final class VideoPlayerTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformVideoPlayer = AVPlayerViewController
    #elseif canImport(AppKit)
    typealias PlatformVideoPlayer = NSColorWell
    #endif

    func testVideoPlayer() throws {
        guard #available(iOS 14, macOS 11, *) else {
            throw XCTSkip()
        }

        let videoURL = URL(string: "https://bit.ly/swswift")!

        XCTAssertViewIntrospection(of: PlatformVideoPlayer.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    #if os(iOS)
                    .introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17), customize: spy0)
//                    #elseif os(macOS)
//                    .introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14), customize: spy0)
                    #endif

                VideoPlayer(player: AVPlayer(url: videoURL))
                    #if os(iOS)
                    .introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17), customize: spy1)
//                    #elseif os(macOS)
//                    .introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14), customize: spy1)
                    #endif

                VideoPlayer(player: AVPlayer(url: videoURL))
                    #if os(iOS)
                    .introspect(.videoPlayer, on: .iOS(.v14, .v15, .v16, .v17), customize: spy2)
//                    #elseif os(macOS)
//                    .introspect(.videoPlayer, on: .macOS(.v11, .v12, .v13, .v14), customize: spy2)
                    #endif
            }
        }
//    extraAssertions: {
//            #if canImport(UIKit)
//            XCTAssertEqual($0[safe: 0]?.selectedColor, .red)
//            XCTAssertEqual($0[safe: 1]?.selectedColor, .green)
//            XCTAssertEqual($0[safe: 2]?.selectedColor, .blue)
//            #elseif canImport(AppKit)
//            XCTAssertEqual($0[safe: 0]?.color, .red)
//            XCTAssertEqual($0[safe: 1]?.color, .green)
//            XCTAssertEqual($0[safe: 2]?.color, .blue)
//            #endif
//        }
    }
}
#endif
