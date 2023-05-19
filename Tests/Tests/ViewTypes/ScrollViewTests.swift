import SwiftUI
import SwiftUIIntrospect
import XCTest

final class ScrollViewTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformScrollView = UIScrollView
    #elseif canImport(AppKit)
    typealias PlatformScrollView = NSScrollView
    #endif

    func testScrollView() throws {
        struct ScrollTestView: View {
            let spy1: (PlatformScrollView) -> Void
            let spy2: (PlatformScrollView) -> Void

            var body: some View {
                HStack {
                    ScrollView {
                        Text("Item 1")
                    }
                    #if os(iOS) || os(tvOS)
                    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #endif
                    ScrollView {
                        Text("Item 1")
                        #if os(iOS) || os(tvOS)
                        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                            self.spy2(scrollView)
                        }
                        #elseif os(macOS)
                        .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                            self.spy2(scrollView)
                        }
                        #endif
                    }
                }
            }
        }

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: PlatformScrollView?
        var scrollView2: PlatformScrollView?

        let view = ScrollTestView(
            spy1: {
                if let scrollView1 = scrollView1 {
                    XCTAssert(scrollView1 === $0)
                }
                scrollView1 = $0
                expectation1.fulfill()
            },
            spy2: {
                if let scrollView2 = scrollView2 {
                    XCTAssert(scrollView2 === $0)
                }
                scrollView2 = $0
                expectation2.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollView1 = try XCTUnwrap(scrollView1)
        let unwrappedScrollView2 = try XCTUnwrap(scrollView2)

        XCTAssertNotEqual(unwrappedScrollView1, unwrappedScrollView2)
    }

    func testNestedScrollView() throws {
        struct NestedScrollTestView: View {
            let spy1: (PlatformScrollView) -> Void
            let spy2: (PlatformScrollView) -> Void

            var body: some View {
                HStack {
                    ScrollView(showsIndicators: true) {
                        Text("Item 1")

                        ScrollView(showsIndicators: false) {
                            Text("Item 1")
                        }
                        #if os(iOS) || os(tvOS)
                        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                            self.spy2(scrollView)
                        }
                        #elseif os(macOS)
                        .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                            self.spy2(scrollView)
                        }
                        #endif
                    }
                    #if os(iOS) || os(tvOS)
                    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #endif
                }
            }
        }

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: PlatformScrollView?
        var scrollView2: PlatformScrollView?

        let view = NestedScrollTestView(
            spy1: {
                if let scrollView1 = scrollView1 {
                    XCTAssert(scrollView1 === $0)
                }
                scrollView1 = $0
                expectation1.fulfill()
            },
            spy2: {
                if let scrollView2 = scrollView2 {
                    XCTAssert(scrollView2 === $0)
                }
                scrollView2 = $0
                expectation2.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollView1 = try XCTUnwrap(scrollView1)
        let unwrappedScrollView2 = try XCTUnwrap(scrollView2)

        XCTAssertNotEqual(unwrappedScrollView1, unwrappedScrollView2)
    }

    func testMaskedScrollView() throws {
        struct MaskedScrollTestView: View {
            let spy1: (PlatformScrollView) -> Void
            let spy2: (PlatformScrollView) -> Void

            var body: some View {
                HStack {
                    ScrollView {
                        Text("Item 1")
                    }
                    #if os(iOS) || os(tvOS)
                    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                        self.spy1(scrollView)
                    }
                    #endif
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    .cornerRadius(2.0)
                    ScrollView {
                        Text("Item 1")
                            #if os(iOS) || os(tvOS)
                            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                                self.spy2(scrollView)
                            }
                            #elseif os(macOS)
                            .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                                self.spy2(scrollView)
                            }
                            #endif
                    }
                }
            }
        }

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: PlatformScrollView?
        var scrollView2: PlatformScrollView?

        let view = MaskedScrollTestView(
            spy1: {
                if let scrollView1 = scrollView1 {
                    XCTAssert(scrollView1 === $0)
                }
                scrollView1 = $0
                expectation1.fulfill()
            },
            spy2: {
                if let scrollView2 = scrollView2 {
                    XCTAssert(scrollView2 === $0)
                }
                scrollView2 = $0
                expectation2.fulfill()
            }
        )

        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollView1 = try XCTUnwrap(scrollView1)
        let unwrappedScrollView2 = try XCTUnwrap(scrollView2)

        XCTAssertNotEqual(unwrappedScrollView1, unwrappedScrollView2)
    }
}
