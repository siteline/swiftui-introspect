#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class ViewControllerTests: XCTestCase {
    func testViewController() {
        XCTAssertViewIntrospection(of: PlatformViewController.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            TabView {
                NavigationView {
                    Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                        .introspect(
                            .viewController,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy2
                        )
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Page 1")
                }
                .introspect(
                    .viewController,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                    customize: spy1
                )
            }
            .introspect(
                .viewController,
                on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                customize: spy0
            )
        } extraAssertions: {
            XCTAssert($0[safe: 0] is UITabBarController)
            XCTAssert($0[safe: 1] is UINavigationController)
            XCTAssert(String(describing: $0[safe: 2]).contains("UIHostingController"))
            XCTAssert($0[safe: 1] === $0[safe: 2]?.parent)
        }
    }
}
#endif
