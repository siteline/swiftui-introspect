#if compiler(>=6.2) && canImport(WebKit)
import SwiftUI
import SwiftUIIntrospect
import Testing
import WebKit

@MainActor
@Suite
struct WebViewTests {
    @available(iOS 26, tvOS 26, macOS 26, visionOS 26, *)
    @Test func webView() async throws {
        XCTAssertViewIntrospection(of: WKWebView.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                WebView(url: nil)
                    .introspect(
                        .webView,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy0
                    )

                WebView(url: nil)
                    .introspect(
                        .webView,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy1
                    )

                WebView(url: nil)
                    .introspect(
                        .webView,
                        on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
                        customize: spy2
                    )
            }
        } extraAssertions: {
            #expect($0[safe: 0] !== $0[safe: 1])
            #expect($0[safe: 0] !== $0[safe: 2])
            #expect($0[safe: 1] !== $0[safe: 2])
        }
    }
}
#endif
