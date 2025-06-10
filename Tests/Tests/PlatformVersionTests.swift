@_spi(Internals) import SwiftUIIntrospect
import XCTest

final class PlatformVersionTests: XCTestCase {
    func test_iOS_isCurrent() {
        #if os(iOS)
        if #available(iOS 26, *) {
            XCTAssertEqual(iOSVersion.v26.isCurrent, true)
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 18, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, true)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 17, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, true)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 16, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, true)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 15, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, true)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 14, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, true)
            XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        } else if #available(iOS 13, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrent, false)
            XCTAssertEqual(iOSVersion.v17.isCurrent, false)
            XCTAssertEqual(iOSVersion.v16.isCurrent, false)
            XCTAssertEqual(iOSVersion.v15.isCurrent, false)
            XCTAssertEqual(iOSVersion.v14.isCurrent, false)
            XCTAssertEqual(iOSVersion.v13.isCurrent, true)
        }
        #else
        XCTAssertEqual(iOSVersion.v26.isCurrent, false)
        XCTAssertEqual(iOSVersion.v18.isCurrent, false)
        XCTAssertEqual(iOSVersion.v17.isCurrent, false)
        XCTAssertEqual(iOSVersion.v16.isCurrent, false)
        XCTAssertEqual(iOSVersion.v15.isCurrent, false)
        XCTAssertEqual(iOSVersion.v14.isCurrent, false)
        XCTAssertEqual(iOSVersion.v13.isCurrent, false)
        #endif
    }

    func test_iOS_isCurrentOrPast() {
        #if os(iOS)
        if #available(iOS 26, *) {
            XCTAssertEqual(iOSVersion.v26.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 18, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 17, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 16, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 15, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 14, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        } else if #available(iOS 13, *) {
            XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, true)
        }
        #else
        XCTAssertEqual(iOSVersion.v26.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v18.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v17.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v16.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v15.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v14.isCurrentOrPast, false)
        XCTAssertEqual(iOSVersion.v13.isCurrentOrPast, false)
        #endif
    }

    func test_macOS_isCurrent() {
        #if os(macOS)
        if #available(macOS 26, *) {
            XCTAssertEqual(macOSVersion.v26.isCurrent, true)
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 15, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, true)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 14, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, true)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 13, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, true)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 12, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, true)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 11, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        } else if #available(macOS 10.15, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrent, false)
            XCTAssertEqual(macOSVersion.v14.isCurrent, false)
            XCTAssertEqual(macOSVersion.v13.isCurrent, false)
            XCTAssertEqual(macOSVersion.v12.isCurrent, false)
            XCTAssertEqual(macOSVersion.v11.isCurrent, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrent, true)
        }
        #else
        XCTAssertEqual(macOSVersion.v26.isCurrent, false)
        XCTAssertEqual(macOSVersion.v15.isCurrent, false)
        XCTAssertEqual(macOSVersion.v14.isCurrent, false)
        XCTAssertEqual(macOSVersion.v13.isCurrent, false)
        XCTAssertEqual(macOSVersion.v12.isCurrent, false)
        XCTAssertEqual(macOSVersion.v11.isCurrent, false)
        XCTAssertEqual(macOSVersion.v10_15.isCurrent, false)
        #endif
    }

    func test_macOS_isCurrentOrPast() {
        #if os(macOS)
        if #available(macOS 26, *) {
            XCTAssertEqual(macOSVersion.v26.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 15, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 14, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 13, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 12, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 11, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, true)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        } else if #available(macOS 10.15, *) {
            XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, false)
            XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, true)
        }
        #else
        XCTAssertEqual(macOSVersion.v26.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v15.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v14.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v13.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v12.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v11.isCurrentOrPast, false)
        XCTAssertEqual(macOSVersion.v10_15.isCurrentOrPast, false)
        #endif
    }

    func test_tvOS_isCurrent() {
        #if os(tvOS)
        if #available(tvOS 26, *) {
            XCTAssertEqual(tvOSVersion.v26.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 18, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 17, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 16, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 15, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 14, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        } else if #available(tvOS 13, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrent, true)
        }
        #else
        XCTAssertEqual(tvOSVersion.v26.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v18.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v17.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v16.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v15.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v14.isCurrent, false)
        XCTAssertEqual(tvOSVersion.v13.isCurrent, false)
        #endif
    }

    func test_tvOS_isCurrentOrPast() {
        #if os(tvOS)
        if #available(tvOS 26, *) {
            XCTAssertEqual(tvOSVersion.v26.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 18, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 17, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 16, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 15, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 14, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, true)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        } else if #available(tvOS 13, *) {
            XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, false)
            XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, true)
        }
        #else
        XCTAssertEqual(tvOSVersion.v26.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v18.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v17.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v16.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v15.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v14.isCurrentOrPast, false)
        XCTAssertEqual(tvOSVersion.v13.isCurrentOrPast, false)
        #endif
    }

    func test_visionOS_isCurrent() {
        #if os(visionOS)
        if #available(visionOS 26, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrent, true)
            XCTAssertEqual(visionOSVersion.v2.isCurrent, false)
            XCTAssertEqual(visionOSVersion.v1.isCurrent, false)
        } else if #available(visionOS 2, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrent, false)
            XCTAssertEqual(visionOSVersion.v2.isCurrent, true)
            XCTAssertEqual(visionOSVersion.v1.isCurrent, false)
        } else if #available(visionOS 1, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrent, false)
            XCTAssertEqual(visionOSVersion.v2.isCurrent, false)
            XCTAssertEqual(visionOSVersion.v1.isCurrent, true)
        }
        #else
        XCTAssertEqual(visionOSVersion.v26.isCurrent, false)
        XCTAssertEqual(visionOSVersion.v2.isCurrent, false)
        XCTAssertEqual(visionOSVersion.v1.isCurrent, false)
        #endif
    }

    func test_visionOS_isCurrentOrPast() {
        #if os(visionOS)
        if #available(visionOS 26, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrentOrPast, true)
            XCTAssertEqual(visionOSVersion.v2.isCurrentOrPast, true)
            XCTAssertEqual(visionOSVersion.v1.isCurrentOrPast, true)
        } else if #available(visionOS 2, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrentOrPast, false)
            XCTAssertEqual(visionOSVersion.v2.isCurrentOrPast, true)
            XCTAssertEqual(visionOSVersion.v1.isCurrentOrPast, true)
        } else if #available(visionOS 1, *) {
            XCTAssertEqual(visionOSVersion.v26.isCurrentOrPast, false)
            XCTAssertEqual(visionOSVersion.v2.isCurrentOrPast, false)
            XCTAssertEqual(visionOSVersion.v1.isCurrentOrPast, true)
        }
        #else
        XCTAssertEqual(visionOSVersion.v26.isCurrentOrPast, false)
        XCTAssertEqual(visionOSVersion.v2.isCurrentOrPast, false)
        XCTAssertEqual(visionOSVersion.v1.isCurrentOrPast, false)
        #endif
    }
}
