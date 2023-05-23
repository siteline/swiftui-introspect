#if !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 16, tvOS 16, macOS 13, *)
final class NavigationSplitViewTests: XCTestCase {
    #if canImport(UIKit) && os(iOS)
    typealias PlatformNavigationSplitView = UISplitViewController
    #elseif canImport(UIKit) && os(tvOS)
    typealias PlatformNavigationSplitView = UINavigationController
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
                #if os(iOS)
                .introspect(.navigationSplitView, on: .iOS(.v16)) { splitViewController in
                    self.spy(splitViewController)
                }
                #elseif os(tvOS)
                .introspect(.navigationSplitView, on: .tvOS(.v16)) { navigationController in
                    self.spy(navigationController)
                }
                #elseif os(macOS)
                .introspect(.navigationSplitView, on: .macOS(.v13)) { splitView in
                    self.spy(splitView)
                }
                #endif
            }
        }

        let expectation = XCTestExpectation()

        var navigationSplitView: PlatformNavigationSplitView?

        let view = NavigationSplitViewTestView(
            spy: {
                if let navigationSplitView = navigationSplitView {
                    XCTAssert(navigationSplitView === $0)
                }
                navigationSplitView = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        XCTAssertNotNil(navigationSplitView)
    }

    func testNavigationSplitViewAsAncestor() throws {
        guard #available(iOS 16, tvOS 16, macOS 13, *) else {
            throw XCTSkip()
        }

        struct NavigationSplitViewTestView: View {
            let spy: (PlatformNavigationSplitView) -> Void

            var body: some View {
                NavigationSplitView(columnVisibility: .constant(.all)) {
                    ZStack {
                        Color.red
                        Text("Sidebar")
                            #if os(iOS)
                            .introspect(.navigationSplitView, on: .iOS(.v16)) { splitViewController in
                                self.spy(splitViewController)
                            }
                            #elseif os(tvOS)
                            .introspect(.navigationSplitView, on: .tvOS(.v16)) { navigationController in
                                self.spy(navigationController)
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

        var navigationSplitView: PlatformNavigationSplitView?

        let view = NavigationSplitViewTestView(
            spy: {
                if let navigationSplitView = navigationSplitView {
                    XCTAssert(navigationSplitView === $0)
                }
                navigationSplitView = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        _ = try XCTUnwrap(navigationSplitView)
    }
}
#endif
