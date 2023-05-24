#if !os(macOS) && !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class NavigationViewWithStackStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformNavigationViewWithStackStyle = UINavigationController
    #endif

    func testNavigationViewWithStackStyleAsReceiver() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithStackStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            .navigationViewStyle(.stack)
            #if os(iOS) || os(tvOS)
            .introspect(.navigationViewWithStackStyle, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), customize: spy)
            #endif
        }
    }

    func testNavigationViewWithStackStyleAsAncestor() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithStackStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS) || os(tvOS)
                        .introspect(.navigationViewWithStackStyle, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), customize: spy)
                        #endif
                }
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif