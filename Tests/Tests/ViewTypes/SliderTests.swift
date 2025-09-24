#if !os(tvOS) && !os(visionOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct SliderTests {
	#if canImport(UIKit)
	typealias PlatformSlider = UISlider
	#elseif canImport(AppKit)
	typealias PlatformSlider = NSSlider
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformSlider.self) { spy1, spy2, spy3 in
			VStack {
				Slider(value: .constant(0.2), in: 0...1)
					#if os(iOS)
					.introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.slider, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				Slider(value: .constant(0.5), in: 0...1)
					#if os(iOS)
					.introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.slider, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				Slider(value: .constant(0.8), in: 0...1)
					#if os(iOS)
					.introspect(.slider, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.slider, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.value == 0.2)
		#expect(entity2.value == 0.5)
		#expect(entity3.value == 0.8)
		#elseif canImport(AppKit)
		#expect(entity1.floatValue == 0.2)
		#expect(entity2.floatValue == 0.5)
		#expect(entity3.floatValue == 0.8)
		#endif
	}
}
#endif
