#if !os(tvOS) && !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct DatePickerWithWheelStyleTests {
	typealias PlatformDatePickerWithWheelStyle = UIDatePicker

	@Test func introspect() async throws {
		let date1 = Date(timeIntervalSince1970: 0)
		let date2 = Date(timeIntervalSince1970: 5)
		let date3 = Date(timeIntervalSince1970: 10)

		let (entity1, entity2, entity3) = try await introspection(of: PlatformDatePickerWithWheelStyle.self) { spy1, spy2, spy3 in
			VStack {
				DatePicker("", selection: .constant(date1))
					.datePickerStyle(.wheel)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					.cornerRadius(8)

				DatePicker("", selection: .constant(date2))
					.datePickerStyle(.wheel)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					.cornerRadius(8)

				DatePicker("", selection: .constant(date3))
					.datePickerStyle(.wheel)
					.introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
			}
		}
		#expect(entity1.date == date1)
		#expect(entity2.date == date2)
		#expect(entity3.date == date3)
	}
}
#endif
