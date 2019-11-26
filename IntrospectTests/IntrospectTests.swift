import XCTest
import SwiftUI

@testable import Introspect

struct ListView: View {
    let spy: () -> Void
    var body: some View {
        List {
            Text("Item 1")
            Text("Item 2")
        }
        .introspectTableView { tableView in
            self.spy()
        }
    }
}

class IntrospectTests: XCTestCase {
    func testCallsCustomize() {
        let expectation = XCTestExpectation()
        let view = ListView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
}
