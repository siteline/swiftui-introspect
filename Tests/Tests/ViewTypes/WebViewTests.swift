#if canImport(WebKit)
import SwiftUI
import SwiftUIIntrospect
import WebKit
import XCTest

@available(iOS 26, tvOS 26, macOS 26, *)
@MainActor
final class WebViewTests: XCTestCase {
    typealias PlatformMap = WKWebView

    func testWebView() throws {
        XCTAssertViewIntrospection(of: PlatformMap.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                WebView(url: nil)
                    .introspect(
                        .map,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy0
                    )

                WebView(url: nil)
                    .introspect(
                        .map,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy1
                    )

                WebView(url: nil)
                    .introspect(
                        .map,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy2
                    )
            }
        } extraAssertions: {
            XCTAssertNotIdentical($0[safe: 0], $0[safe: 1])
            XCTAssertNotIdentical($0[safe: 0], $0[safe: 2])
            XCTAssertNotIdentical($0[safe: 1], $0[safe: 2])
        }
    }
}
#endif
