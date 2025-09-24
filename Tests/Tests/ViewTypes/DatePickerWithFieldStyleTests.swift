#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct DatePickerWithFieldStyleTests {
	typealias PlatformDatePickerWithFieldStyle = NSDatePicker

	@Test func introspect() async throws {
		let date1 = Date(timeIntervalSince1970: 0)
		let date2 = Date(timeIntervalSince1970: 5)
		let date3 = Date(timeIntervalSince1970: 10)

		let (entity1, entity2, entity3) = try await introspection(of: PlatformDatePickerWithFieldStyle.self) { spy1, spy2, spy3 in
			VStack {
				DatePicker("", selection: .constant(date1))
					.datePickerStyle(.field)
					.introspect(.datePicker(style: .field), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					.cornerRadius(8)

				DatePicker("", selection: .constant(date2))
					.datePickerStyle(.field)
					.introspect(.datePicker(style: .field), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					.cornerRadius(8)

				DatePicker("", selection: .constant(date3))
					.datePickerStyle(.field)
					.introspect(.datePicker(style: .field), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
			}
		}
		#expect(entity1.dateValue == date1)
		#expect(entity2.dateValue == date2)
		#expect(entity3.dateValue == date3)
	}
}
#endif
