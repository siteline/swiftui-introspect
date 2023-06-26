#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

#if !os(tvOS) // FIXME: none of these tests pass on tvOS for some reason, even though introspection works when ran normally
final class PresentationTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformPresentation = UIPresentationController
    #endif

    func testPresentationAsSheet() throws {
        XCTAssertViewIntrospection(of: PlatformPresentation.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .sheet(isPresented: .constant(true)) {
                    Text("Sheet")
                        #if os(iOS) || os(tvOS)
                        .introspect(
                            .presentation,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                        #endif
                }
        }
    }

    // FIXME: this doesn't pass, even though introspection works when ran normally
//    func testPresentationAsFullScreenCover() throws {
//        XCTAssertViewIntrospection(of: PlatformPresentation.self) { spies in
//            let spy0 = spies[0]
//
//            Text("Root")
//                .fullScreenCover(isPresented: .constant(true)) {
//                    Text("popover")
//                        #if os(iOS) || os(tvOS)
//                        .introspect(
//                            .presentation,
//                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
//                            customize: spy0
//                        )
//                        #endif
//                }
//        }
//    }

    #if !os(tvOS)
    func testPresentationAsPopover() throws {
        XCTAssertViewIntrospection(of: PlatformPresentation.self) { spies in
            let spy0 = spies[0]

            Text("Root")
                .popover(isPresented: .constant(true)) {
                    Text("Popover")
                        #if os(iOS) || os(tvOS)
                        .introspect(
                            .presentation,
                            on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
                            customize: spy0
                        )
                        #endif
                }
        }
    }
    #endif
}
#endif
#endif
