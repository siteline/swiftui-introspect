#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
struct PageControlTests {
	typealias PlatformPageControl = UIPageControl

	@Test func introspect() async throws {
		try await introspection(of: PlatformPageControl.self) { spy in
			TabView {
				Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
				Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
			}
			.tabViewStyle(.page(indexDisplayMode: .always))
			.introspect(
				.pageControl,
				on: .iOS(.v14, .v15, .v16, .v17, .v18),
				.tvOS(.v14, .v15, .v16, .v17, .v18),
				.visionOS(.v1, .v2),
				customize: spy,
			)
		}
	}
}
#endif
