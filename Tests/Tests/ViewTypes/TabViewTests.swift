#if !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@MainActor
final class TabViewTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformTabView = UITabBarController
    #elseif canImport(AppKit)
    typealias PlatformTabView = NSTabView
    #endif

    func testTabView() throws {
        guard #unavailable(macOS 15) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformTabView.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            #if os(iOS) || os(tvOS)
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18), customize: spy)
            #elseif os(macOS)
            .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), customize: spy)
            #endif
        }
    }

    func testTabViewAsAncestor() throws {
        guard #unavailable(macOS 15) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformTabView.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS) || os(tvOS)
                        .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18), scope: .ancestor, customize: spy)
                        #elseif os(macOS)
                        .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14), scope: .ancestor, customize: spy)
                        #endif
                }
            }
        }
    }
}
#endif
