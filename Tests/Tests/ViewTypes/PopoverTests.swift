#if !os(tvOS) && !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PopoverTests {
	@Test func introspect() async throws {
		try await introspection(of: UIPopoverPresentationController.self) { spy in
			Text("Root")
				.popover(isPresented: .constant(true)) {
					Text("Popover")
						.introspect(
							.popover,
							on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
							customize: spy
						)
				}
		}
	}
}
#endif
