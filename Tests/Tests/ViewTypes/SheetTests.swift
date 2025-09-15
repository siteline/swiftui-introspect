#if !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct SheetTests {
	#if os(iOS)
	@Test func introspect() async throws {
		try await introspection(of: UIPresentationController.self) { spy in
			Text("Root")
				.sheet(isPresented: .constant(true)) {
					Text("Sheet")
						.introspect(
							.sheet,
							on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26),
							customize: spy
						)
				}
		}
	}

	@available(iOS 15, tvOS 15, *)
	@Test func introspectAsSheetPresentationController() async throws {
		try await introspection(of: UISheetPresentationController.self) { spy in
			Text("Root")
				.sheet(isPresented: .constant(true)) {
					Text("Sheet")
						.introspect(
							.sheet,
							on: .iOS(.v15, .v16, .v17, .v18, .v26),
							customize: spy
						)
				}
		}
	}
	#elseif os(tvOS)
	@Test func introspect() async throws {
		try await introspection(of: UIPresentationController.self) { spy in
			Text("Root")
				.sheet(isPresented: .constant(true)) {
					Text("Content")
						.introspect(
							.sheet,
							on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26),
							customize: spy
						)
				}
		}
	}
	#elseif os(visionOS)
	@Test func introspect() async throws {
		try await introspection(of: UIPresentationController.self) { spy in
			Text("Root")
				.sheet(isPresented: .constant(true)) {
					Text("Sheet")
						.introspect(
							.sheet,
							on: .visionOS(.v1, .v2, .v26),
							customize: spy
						)
				}
		}
	}
	#endif
}
#endif
