#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TabViewWithPageStyleTests {
	typealias PlatformTabViewWithPageStyle = UICollectionView

	@Test func introspect() async throws {
		try await introspection(of: PlatformTabViewWithPageStyle.self) { spy in
			TabView {
				Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
				Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
			}
			.tabViewStyle(.page)
			.introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
		}
	}

	@Test func introspectAsAncestor() async throws {
		try await introspection(of: PlatformTabViewWithPageStyle.self) { spy in
			TabView {
				Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
					.introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
				Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
			}
			.tabViewStyle(.page)
		}
	}
}
#endif
