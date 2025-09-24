#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ButtonTests {
	typealias PlatformButton = NSButton

	@available(macOS, introduced: 10.15, obsoleted: 26.0)
	@Test func introspectButtonsBeforeMacOS26() async throws {
		let (entity1, entity2, entity3, entity4) = try await introspection(of: PlatformButton.self) { spy1, spy2, spy3, spy4 in
			VStack {
				Button("Plain Button", action: {})
					.introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15), customize: spy1)

				Button("Bordered Button", action: {})
					.buttonStyle(.bordered)
					.introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15), customize: spy2)

				Button("Borderless Button", action: {})
					.buttonStyle(.borderless)
					.introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15), customize: spy3)

				Button("Link Button", action: {})
					.buttonStyle(.link)
					.introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15), customize: spy4)
			}
		}
		#expect(Set([entity1, entity2, entity3, entity4].map(ObjectIdentifier.init)).count == 4)
	}

	@available(macOS 26, *)
	@Test func introspectButtonsOnMacOS26() async throws {
		let (entity1, entity2) = try await introspection(of: NSButton.self) { spy1, spy2 in
			VStack {
				Button("Borderless Button", action: {})
					.buttonStyle(.borderless)
					.introspect(.button, on: .macOS(.v26), customize: spy1)

				Button("Link Button", action: {})
					.buttonStyle(.link)
					.introspect(.button, on: .macOS(.v26), customize: spy2)
			}
		}
		#expect(Set([entity1, entity2].map(ObjectIdentifier.init)).count == 2)
	}
}
#endif
