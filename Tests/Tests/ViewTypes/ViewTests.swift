#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class ViewTests: XCTestCase {
    func testView() {
        XCTAssertViewIntrospection(of: PlatformViewController.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]

            VStack {
                NavigationView {
                    Text("Item 0")
                        #if os(iOS) || os(tvOS)
                        .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), customize: spy0)
                        #endif
                }
                .navigationViewStyle(.stack)

                NavigationView {
                    Text("Item 1")
                        #if os(iOS) || os(tvOS)
                        .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), customize: spy1)
                        #endif
                }
                .navigationViewStyle(.stack)
            }
        } extraAssertions: {
            XCTAssert($0[safe: 0] !== $0[safe: 1])
        }
    }
}
#endif
