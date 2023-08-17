#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class FullScreenCoverTests: XCTestCase {
    func testPresentationAsFullScreenCover() throws {
        #if !os(visionOS)
        throw XCTSkip("FIXME: this doesn't pass on anything other than visionOS, even though introspection works in the Showcase app")
        #endif

        guard #available(iOS 14, tvOS 14, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: UIPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .fullScreenCover(isPresented: .constant(true)) {
                    Text("Content")
                        #if os(iOS) || os(tvOS) || os(visionOS)
                        .introspect(
                            .fullScreenCover,
                            on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .visionOS(.v1),
                            customize: spy0
                        )
                        #endif
                }
        }
    }
}
#endif
