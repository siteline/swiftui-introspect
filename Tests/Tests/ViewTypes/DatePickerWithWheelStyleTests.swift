#if !os(tvOS) && !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct DatePickerWithWheelStyleTests {
	#if canImport(UIKit)
	typealias PlatformDatePickerWithWheelStyle = UIDatePicker
	#endif

	@Test func introspect() async throws {
		let date1 = Date(timeIntervalSince1970: 0)
		let date2 = Date(timeIntervalSince1970: 5)
		let date3 = Date(timeIntervalSince1970: 10)

		let (entity1, entity2, entity3) = try await introspection(of: PlatformDatePickerWithWheelStyle.self) { spy1, spy2, spy3 in
			VStack {
				DatePicker("", selection: .constant(date1))
					.datePickerStyle(.wheel)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				DatePicker("", selection: .constant(date2))
					.datePickerStyle(.wheel)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				DatePicker("", selection: .constant(date3))
					.datePickerStyle(.wheel)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.date == date1)
		#expect(entity2.date == date2)
		#expect(entity3.date == date3)
		#endif
	}
}
#endif
