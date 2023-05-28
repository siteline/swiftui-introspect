#if !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

final class TabViewTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformTabView = UITabBarController
    #elseif canImport(AppKit)
    typealias PlatformTabView = NSTabView
    #endif

    func testTabView() {
        XCTAssertViewIntrospection(of: PlatformTabView.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            #if os(iOS) || os(tvOS)
            .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), customize: spy)
            #elseif os(macOS)
            .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13), customize: spy)
            #endif
        }
    }

    func testTabViewAsAncestor() {
        XCTAssertViewIntrospection(of: PlatformTabView.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS) || os(tvOS)
                        .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), scope: .ancestor, customize: spy)
                        #elseif os(macOS)
                        .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13), scope: .ancestor, customize: spy)
                        #endif
                }
            }
        }
    }
}
#endif
