#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 16, tvOS 16, *)
final class NavigationStackTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformNavigationStack = UINavigationController
    #endif

    func testNavigationStackAsReceiver() throws {
        guard #available(iOS 16, tvOS 16, *) else {
            throw XCTSkip()
        }

        struct NavigationStackTestView: View {
            let spy: (PlatformNavigationStack) -> Void

            var body: some View {
                NavigationStack {
                    ZStack {
                        Color.red
                        Text("Something")
                    }
                }
                #if os(iOS) || os(tvOS)
                .introspect(.navigationStack, on: .iOS(.v16), .tvOS(.v16)) { navigationController in
                    self.spy(navigationController)
                }
                #endif
            }
        }

        let expectation = XCTestExpectation()

        var navigationController: PlatformNavigationStack?

        let view = NavigationStackTestView(
            spy: {
                if let navigationController = navigationController {
                    XCTAssert(navigationController === $0)
                }
                navigationController = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        XCTAssertNotNil(navigationController)
    }

    func testNavigationStackAsAncestor() throws {
        guard #available(iOS 16, tvOS 16, *) else {
            throw XCTSkip()
        }

        struct NavigationStackTestView: View {
            let spy: (PlatformNavigationStack) -> Void

            var body: some View {
                NavigationStack {
                    ZStack {
                        Color.red
                        Text("Something")
                            #if os(iOS) || os(tvOS)
                            .introspect(.navigationStack, on: .iOS(.v16), .tvOS(.v16)) { navigationController in
                                self.spy(navigationController)
                            }
                            #endif
                    }
                }
            }
        }

        let expectation = XCTestExpectation()

        var navigationController: PlatformNavigationStack?

        let view = NavigationStackTestView(
            spy: {
                if let navigationController = navigationController {
                    XCTAssert(navigationController === $0)
                }
                navigationController = $0
                expectation.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)

        XCTAssertNotNil(navigationController)
    }
}
#endif
