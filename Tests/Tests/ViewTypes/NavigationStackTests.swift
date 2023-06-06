#if !os(macOS) && !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 16, tvOS 16, *)
final class NavigationStackTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformNavigationStack = UINavigationController
    #endif

    func testNavigationStack() throws {
        guard #available(iOS 16, tvOS 16, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformNavigationStack.self) { spies in
            let spy = spies[0]

            NavigationStack {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            #if os(iOS) || os(tvOS)
            .introspect(.navigationStack, on: .iOS(.v16, .v17), .tvOS(.v16, .v17), customize: spy)
            #endif
        }
    }

    func testNavigationStackAsAncestor() throws {
        guard #available(iOS 16, tvOS 16, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformNavigationStack.self) { spies in
            let spy = spies[0]

            NavigationStack {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS) || os(tvOS)
                        .introspect(.navigationStack, on: .iOS(.v16, .v17), .tvOS(.v16, .v17), scope: .ancestor, customize: spy)
                        #endif
                }
            }
        }
    }
}
#endif
