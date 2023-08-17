#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 14, *)
final class DatePickerWithGraphicalStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformDatePickerWithGraphicalStyle = UIDatePicker
    #elseif canImport(AppKit)
    typealias PlatformDatePickerWithGraphicalStyle = NSDatePicker
    #endif

    func testDatePickerWithGraphicalStyle() throws {
        guard #available(iOS 14, *) else {
            throw XCTSkip()
        }

        let date0 = Date(timeIntervalSince1970: 0)
        let date1 = Date(timeIntervalSince1970: 3600 * 24 * 1)
        let date2 = Date(timeIntervalSince1970: 3600 * 24 * 2)

        XCTAssertViewIntrospection(of: PlatformDatePickerWithGraphicalStyle.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                DatePicker("", selection: .constant(date0))
                    .datePickerStyle(.graphical)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .graphical), on: .iOS(.v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy0)
                    #elseif os(macOS)
                    .introspect(.datePicker(style: .graphical), on: .macOS(.v10_15, .v11, .v12, .v13, .v14), customize: spy0)
                    #endif
                    .cornerRadius(8)

                DatePicker("", selection: .constant(date1))
                    .datePickerStyle(.graphical)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .graphical), on: .iOS(.v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy1)
                    #elseif os(macOS)
                    .introspect(.datePicker(style: .graphical), on: .macOS(.v10_15, .v11, .v12, .v13, .v14), customize: spy1)
                    #endif
                    .cornerRadius(8)

                DatePicker("", selection: .constant(date2))
                    .datePickerStyle(.graphical)
                    #if os(iOS) || os(visionOS)
                    .introspect(.datePicker(style: .graphical), on: .iOS(.v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy2)
                    #elseif os(macOS)
                    .introspect(.datePicker(style: .graphical), on: .macOS(.v10_15, .v11, .v12, .v13, .v14), customize: spy2)
                    #endif
            }
        } extraAssertions: {
            #if canImport(UIKit)
            XCTAssertEqual($0[safe: 0]?.date, date0)
            XCTAssertEqual($0[safe: 1]?.date, date1)
            XCTAssertEqual($0[safe: 2]?.date, date2)
            #elseif canImport(AppKit)
            XCTAssertEqual($0[safe: 0]?.dateValue, date0)
            XCTAssertEqual($0[safe: 1]?.dateValue, date1)
            XCTAssertEqual($0[safe: 2]?.dateValue, date2)
            #endif
        }
    }
}
#endif
