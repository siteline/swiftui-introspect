#if !os(tvOS) && !os(visionOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ToggleTests {
	#if canImport(UIKit)
	typealias PlatformToggle = UISwitch
	#elseif canImport(AppKit)
	typealias PlatformToggle = NSButton
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformToggle.self) { spy1, spy2, spy3 in
			VStack {
				Toggle("", isOn: .constant(true))
					#if os(iOS)
					.introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				Toggle("", isOn: .constant(false))
					#if os(iOS)
					.introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				Toggle("", isOn: .constant(true))
					#if os(iOS)
					.introspect(.toggle, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.toggle, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.isOn == true)
		#expect(entity2.isOn == false)
		#expect(entity3.isOn == true)
		#elseif canImport(AppKit)
		#expect(entity1.state == .on)
		#expect(entity2.state == .off)
		#expect(entity3.state == .on)
		#endif
	}
}
#endif
