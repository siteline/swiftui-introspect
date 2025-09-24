#if !os(tvOS) && !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PickerWithWheelStyleTests {
	#if canImport(UIKit)
	typealias PlatformPickerWithWheelStyle = UIPickerView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformPickerWithWheelStyle.self) { spy1, spy2, spy3 in
			VStack {
				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
				}
				.pickerStyle(.wheel)
				#if os(iOS) || os(visionOS)
				.introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#endif
				.cornerRadius(8)

				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
					Text("2").tag("2")
				}
				.pickerStyle(.wheel)
				#if os(iOS) || os(visionOS)
				.introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
				#endif
				.cornerRadius(8)

				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
					Text("2").tag("2")
					Text("3").tag("3")
				}
				.pickerStyle(.wheel)
				#if os(iOS) || os(visionOS)
				.introspect(.picker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
				#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.numberOfRows(inComponent: 0) == 1)
		#expect(entity2.numberOfRows(inComponent: 0) == 2)
		#expect(entity3.numberOfRows(inComponent: 0) == 3)
		#endif
	}
}
#endif
