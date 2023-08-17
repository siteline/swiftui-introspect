#if !os(tvOS) && !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class DatePickerWithWheelStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformDatePickerWithWheelStyle = UIDatePicker
    #endif

    func testDatePickerWithWheelStyle() {
        let date0 = Date(timeIntervalSince1970: 0)
        let date1 = Date(timeIntervalSince1970: 5)
        let date2 = Date(timeIntervalSince1970: 10)

        XCTAssertViewIntrospection(of: PlatformDatePickerWithWheelStyle.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                DatePicker("", selection: .constant(date0))
                    .datePickerStyle(.wheel)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy0)
                    #endif
                    .cornerRadius(8)

                DatePicker("", selection: .constant(date1))
                    .datePickerStyle(.wheel)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy1)
                    #endif
                    .cornerRadius(8)

                DatePicker("", selection: .constant(date2))
                    .datePickerStyle(.wheel)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .wheel), on: .iOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy2)
                    #endif
            }
        } extraAssertions: {
            #if canImport(UIKit)
            XCTAssertEqual($0[safe: 0]?.date, date0)
            XCTAssertEqual($0[safe: 1]?.date, date1)
            XCTAssertEqual($0[safe: 2]?.date, date2)
            #endif
        }
    }
}
#endif
