#if !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 16, tvOS 16, macOS 13, *)
final class NavigationSplitViewTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformNavigationSplitView = UISplitViewController
    #elseif canImport(AppKit)
    typealias PlatformNavigationSplitView = NSSplitView
    #endif

    func testNavigationSplitViewAsReceiver() throws {
        guard #available(iOS 16, tvOS 16, macOS 13, *) else {
            throw XCTSkip()
        }

        struct NavigationSplitViewTestView: View {
            let spy: (PlatformNavigationSplitView) -> Void

            var body: some View {
                NavigationSplitView {
                    ZStack {
                        Color.red
                        Text("Something")
                    }
                } detail: {
                    ZStack {
                        Color.red
                        Text("Detail")
                    }
                }
                #if os(iOS) || os(tvOS)
                .introspect(.navigationSplitView, on: .iOS(.v16), .tvOS(.v16)) { splitView in
                    self.spy(splitView)
                }
                #elseif os(macOS)
                .introspect(.navigationSplitView, on: .macOS(.v13)) { splitView in
                    self.spy(splitView)
                }
                #endif
            }
        }

        let expectation = XCTestExpectation()

        var splitView: PlatformNavigationSplitView?

        let view = NavigationSplitViewTestView(
            spy: {
                if let splitView = splitView {
                    XCTAssert(splitView === $0)
                }
                splitView = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        XCTAssertNotNil(splitView)
    }

    func testNavigationSplitViewAsAncestor() throws {
        guard #available(iOS 16, tvOS 16, macOS 13, *) else {
            throw XCTSkip()
        }

        struct NavigationSplitViewTestView: View {
            let spy: (PlatformNavigationSplitView) -> Void

            var body: some View {
                NavigationSplitView {
                    ZStack {
                        Color.red
                        Text("Sidebar")
                            #if os(iOS) || os(tvOS)
                            .introspect(.navigationSplitView, on: .iOS(.v16), .tvOS(.v16)) { splitView in
                                self.spy(splitView)
                            }
                            #elseif os(macOS)
                            .introspect(.navigationSplitView, on: .macOS(.v13)) { splitView in
                                self.spy(splitView)
                            }
                            #endif
                    }
                } detail: {
                    Text("Detail")
                }
            }
        }

        let expectation = XCTestExpectation()

        var splitView: PlatformNavigationSplitView?

        let view = NavigationSplitViewTestView(
            spy: {
                if let splitView = splitView {
                    XCTAssert(splitView === $0)
                }
                splitView = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        _ = try XCTUnwrap(splitView)
    }
}
#endif
