#if !os(tvOS) && !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class PopoverTests: XCTestCase {
    func testPopover() throws {
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            throw XCTSkip("FIXME: does not pass on iPad, even though it works in Showcase app")
        }
        #if os(visionOS)
        throw XCTSkip("FIXME: does not pass on visionOS, even though it works in Showcase app")
        #endif

        XCTAssertViewIntrospection(of: UIPopoverPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .popover(isPresented: .constant(true)) {
                    Text("Popover")
                        .introspect(
                            .popover,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1),
                            customize: spy0
                        )
                }
        }
    }
}
#endif
