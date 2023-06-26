#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

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

//    func testPresentationAsFullScreenCover() throws {
//        guard #available(iOS 14, tvOS 14, *) else {
//            throw XCTSkip()
//        }
//
//        struct Something: View {
//            @State var isPresented = false
//
//            let spy: (PlatformPresentation) -> Void
//
//            var body: some View {
//                Text("Root")
//                    .fullScreenCover(isPresented: $isPresented) {
//                        Text("Full Screen Cover")
//                            #if os(iOS) || os(tvOS)
//                            .introspect(
//                                .presentation,
//                                on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17),
//                                customize: spy
//                            )
//                            #endif
//                    }
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            isPresented = true
//                        }
//                    }
//            }
//        }
//
//        XCTAssertViewIntrospection(of: PlatformPresentation.self) { spies in
//            let spy0 = spies[0]
//
//            Something(spy: spy0)
//        }
//    }
}
#endif
