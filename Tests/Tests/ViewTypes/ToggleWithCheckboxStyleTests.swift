#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ToggleWithCheckboxStyleTests {
	typealias PlatformToggleWithCheckboxStyle = NSButton

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformToggleWithCheckboxStyle.self) { spy1, spy2, spy3 in
			VStack {
				Toggle("", isOn: .constant(true))
					.toggleStyle(.checkbox)
					.introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)

				Toggle("", isOn: .constant(false))
					.toggleStyle(.checkbox)
					.introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)

				Toggle("", isOn: .constant(true))
					.toggleStyle(.checkbox)
					.introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
			}
		}
		#expect(entity1.state == .on)
		#expect(entity2.state == .off)
		#expect(entity3.state == .on)
	}
}
#endif
