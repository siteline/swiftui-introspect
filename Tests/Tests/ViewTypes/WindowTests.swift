import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct WindowTests {
	#if canImport(UIKit)
	typealias PlatformWindow = UIWindow
	#elseif canImport(AppKit)
	typealias PlatformWindow = NSWindow
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformWindow.self) { spy1, spy2, spy3 in
			VStack {
				Image(systemName: "scribble")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.window, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.window, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				Text("Text")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.window, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.window, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(.window, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
			#elseif os(macOS)
			.introspect(.window, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
			#endif
		}
		#expect(entity1 === entity2)
		#expect(entity1 === entity3)
		#expect(entity2 === entity3)
	}
}
