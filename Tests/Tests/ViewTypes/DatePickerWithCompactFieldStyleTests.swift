#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct DatePickerWithCompactStyleTests {
	#if canImport(UIKit)
	typealias PlatformDatePickerWithCompactStyle = UIDatePicker
	#elseif canImport(AppKit)
	typealias PlatformDatePickerWithCompactStyle = NSDatePicker
	#endif

	func introspect() async throws {
		let date1 = Date(timeIntervalSince1970: 0)
		let date2 = Date(timeIntervalSince1970: 5)
		let date3 = Date(timeIntervalSince1970: 10)

		let (entity1, entity2, entity3) = try await introspection(of: PlatformDatePickerWithCompactStyle.self) { spy1, spy2, spy3 in
			VStack {
				DatePicker("", selection: .constant(date1))
					.datePickerStyle(.compact)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .compact), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.datePicker(style: .compact), on: .macOS(.v10_15_4, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				DatePicker("", selection: .constant(date2))
					.datePickerStyle(.compact)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .compact), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.datePicker(style: .compact), on: .macOS(.v10_15_4, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				DatePicker("", selection: .constant(date3))
					.datePickerStyle(.compact)
					#if os(iOS) || os(visionOS)
					.introspect(.datePicker(style: .compact), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.datePicker(style: .compact), on: .macOS(.v10_15_4, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.date == date1)
		#expect(entity2.date == date2)
		#expect(entity3.date == date3)
		#elseif canImport(AppKit)
		#expect(entity1.dateValue == date1)
		#expect(entity2.dateValue == date2)
		#expect(entity3.dateValue == date3)
		#endif
	}
}
#endif
