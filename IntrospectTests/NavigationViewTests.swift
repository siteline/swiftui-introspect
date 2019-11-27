import XCTest
import SwiftUI

@testable import Introspect

private struct TestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .introspectNavigationController { navigationController in
                self.spy()
            }
        }
    }
}

class NavigationViewTests: XCTestCase {
    func testCallsCustomize() {
        let expectation = XCTestExpectation()
        let view = TestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
}
