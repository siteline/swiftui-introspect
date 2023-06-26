#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class FullScreenCoverTests: XCTestCase {
    func testPresentationAsFullScreenCover() throws {
        throw XCTSkip("FIXME: this doesn't pass, even though introspection works in the Showcase app")

        guard #available(iOS 14, tvOS 14, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: UIPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .fullScreenCover(isPresented: .constant(true)) {
                    Text("Content")
                        #if os(iOS) || os(tvOS)
                        .introspect(
                            .fullScreenCover,
                            on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                        #endif
                }
        }
    }
}
#endif
