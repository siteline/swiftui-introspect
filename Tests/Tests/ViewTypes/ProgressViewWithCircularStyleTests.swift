import SwiftUI
import SwiftUIIntrospect
import XCTest

final class ProgressViewWithCircularStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformProgressViewWithCircularStyle = UIActivityIndicatorView
    #elseif canImport(AppKit)
    typealias PlatformProgressViewWithCircularStyle = NSProgressIndicator
    #endif

    func testProgressViewWithCircularStyle() throws {
        guard #available(iOS 14, tvOS 14, macOS 11, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformProgressViewWithCircularStyle.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    #if os(iOS) || os(tvOS)
                    .introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), customize: spy0)
                    #elseif os(macOS)
                    .introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13), customize: spy0)
                    #endif

                ProgressView()
                    .progressViewStyle(.circular)
                    #if os(iOS) || os(tvOS)
                    .introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), customize: spy1)
                    #elseif os(macOS)
                    .introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13), customize: spy1)
                    #endif

                ProgressView()
                    .progressViewStyle(.circular)
                    #if os(iOS) || os(tvOS)
                    .introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), customize: spy2)
                    #elseif os(macOS)
                    .introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13), customize: spy2)
                    #endif
            }
        }
    }
}
