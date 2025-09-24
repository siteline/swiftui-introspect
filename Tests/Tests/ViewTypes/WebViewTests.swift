#if canImport(WebKit)
import SwiftUI
import SwiftUIIntrospect
import Testing
import WebKit

@MainActor
@Suite
struct WebViewTests {
	@available(iOS 26, tvOS 26, macOS 26, visionOS 26, *)
	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: WKWebView.self) { spy1, spy2, spy3 in
			VStack {
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

				WebView(url: nil)
					.introspect(
						.webView,
						on: .iOS(.v26), .tvOS(.v26), .macOS(.v26), .visionOS(.v26),
						customize: spy3
					)
			}
		}
		#expect(entity1 !== entity2)
		#expect(entity1 !== entity3)
		#expect(entity2 !== entity3)
	}
}
#endif
