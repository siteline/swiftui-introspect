#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@MainActor
final class NavigationViewWithStackStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformNavigationViewWithStackStyle = UINavigationController
    #endif

    @MainActor
    func testNavigationViewWithStackStyle() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithStackStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            .navigationViewStyle(.stack)
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy)
            #endif
        }
    }

    @MainActor
    func testNavigationViewWithStackStyleAsAncestor() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithStackStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS) || os(tvOS) || os(visionOS)
                        .introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17), .visionOS(.v1), scope: .ancestor, customize: spy)
                        #endif
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif
