@testable import SwiftUIIntrospect
import XCTest

final class PlatformTests: XCTestCase {
    func test_iOS() {
        #if os(iOS)
        if #available(iOS 17, *) {
            XCTAssertEqual(iOSVersion.v17.isCurrent, true)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 16, *) {
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, true)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 15, *) {
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, true)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 14, *) {
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, true)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 13, *) {
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, true)
        }
        #else
        XCTAssertEqual(iOSVersion.v17.isCurrent, false)
        XCTAssertEqual(iOSVersion.v16.isCurrent, false)
        XCTAssertEqual(iOSVersion.v15.isCurrent, false)
        XCTAssertEqual(iOSVersion.v14.isCurrent, false)
        XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        #endif
    }

    func test_macOS() {
        #if os(macOS)
        if #available(macOS 14, *) {
            XCTAssertEqual(macOSVersion.v14.isCurrent, true)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 13, *) {
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, true)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 12, *) {
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, true)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 11, *) {
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 10.15, *) {
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, true)
        }
        #else
        XCTAssertEqual(macOSVersion.v14.isCurrent, false)
        XCTAssertEqual(macOSVersion.v13.isCurrent, false)
        XCTAssertEqual(macOSVersion.v12.isCurrent, false)
        XCTAssertEqual(macOSVersion.v11.isCurrent, false)
        XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        #endif
    }

    func test_tvOS() {
        #if os(tvOS)
        if #available(tvOS 17, *) {
            XCTAssertEqual(tvOSVersion.v17.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 16, *) {
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 15, *) {
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 14, *) {
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 13, *) {
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, true)
        }
        #else
        XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        #endif
    }
}
