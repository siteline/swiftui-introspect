#if !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct FullScreenCoverTests {
	@Test func introspect() async throws {
		try await introspection(of: UIPresentationController.self) { spy in
			Text("Root")
				.fullScreenCover(isPresented: .constant(true)) {
					Text("Content")
						.introspect(
							.fullScreenCover,
							on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
							customize: spy
						)
				}
		}
	}
}
#endif
