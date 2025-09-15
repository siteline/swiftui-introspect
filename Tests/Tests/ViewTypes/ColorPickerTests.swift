#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ColorPickerTests {
	#if canImport(UIKit)
	typealias PlatformColor = UIColor
	typealias PlatformColorPicker = UIColorWell
	#elseif canImport(AppKit)
	typealias PlatformColor = NSColor
	typealias PlatformColorPicker = NSColorWell
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformColorPicker.self) { spy1, spy2, spy3 in
			VStack {
				ColorPicker("", selection: .constant(PlatformColor.red.cgColor))
					#if os(iOS) || os(visionOS)
					.introspect(.colorPicker, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.colorPicker, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				ColorPicker("", selection: .constant(PlatformColor.green.cgColor))
					#if os(iOS) || os(visionOS)
					.introspect(.colorPicker, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.colorPicker, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				ColorPicker("", selection: .constant(PlatformColor.blue.cgColor))
					#if os(iOS) || os(visionOS)
					.introspect(.colorPicker, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.colorPicker, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.selectedColor == .red)
		#expect(entity2.selectedColor == .green)
		#expect(entity3.selectedColor == .blue)
		#elseif canImport(AppKit)
		#expect(entity1.color == .red)
		#expect(entity2.color == .green)
		#expect(entity3.color == .blue)
		#endif
	}
}
#endif
