#if os(iOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class PopoverTests: XCTestCase {
    func testPopover() throws {
        XCTAssertViewIntrospection(of: UIPopoverPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .popover(isPresented: .constant(true)) {
                    Text("Popover")
                        #if os(iOS)
                        .introspect(
                            .popover,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                        #endif
                }
        }
    }
}
#endif
