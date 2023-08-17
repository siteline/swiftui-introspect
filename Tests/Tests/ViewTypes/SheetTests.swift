#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class SheetTests: XCTestCase {
    #if os(iOS)
    func testSheet() throws {
        XCTAssertViewIntrospection(of: UIPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .sheet(isPresented: .constant(true)) {
                    Text("Sheet")
                        .introspect(
                            .sheet,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                }
        }
    }

    func testSheetAsSheetPresentationController() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: UISheetPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .sheet(isPresented: .constant(true)) {
                    Text("Sheet")
                        .introspect(
                            .sheet,
                            on: .iOS(.v15, .v16, .v17),
                            customize: spy0
                        )
                }
        }
    }
    #elseif os(tvOS)
    func testSheet() throws {
        throw XCTSkip("FIXME: this test doesn't pass for some reason, even though introspection works in the Showcase app")

        XCTAssertViewIntrospection(of: UIPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .sheet(isPresented: .constant(true)) {
                    Text("Content")
                        .introspect(
                            .sheet,
                            on: .tvOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                }
        }
    }
    #elseif os(visionOS)
    func testSheet() throws {
        XCTAssertViewIntrospection(of: UIPresentationController.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .sheet(isPresented: .constant(true)) {
                    Text("Sheet")
                        .introspect(
                            .sheet,
                            on: .visionOS(.v1),
                            customize: spy0
                        )
                }
        }
    }
    #endif
}
#endif
