#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ToggleWithButtonStyleTests {
	typealias PlatformToggleWithButtonStyle = NSButton

	@available(macOS, introduced: 12, obsoleted: 26)
	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformToggleWithButtonStyle.self) { spy1, spy2, spy3 in
			VStack {
				Toggle("", isOn: .constant(true))
					.toggleStyle(.button)
					.introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15), customize: spy1)

				Toggle("", isOn: .constant(false))
					.toggleStyle(.button)
					.introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15), customize: spy2)

				Toggle("", isOn: .constant(true))
					.toggleStyle(.button)
					.introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15), customize: spy3)
			}
		}
		#expect(entity1.state == .on)
		#expect(entity2.state == .off)
		#expect(entity3.state == .on)
	}
}
#endif
