#if !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 16, tvOS 16, macOS 13, *)
final class NavigationSplitViewTests: XCTestCase {
    #if canImport(UIKit) && os(iOS)
    typealias PlatformNavigationSplitView = UISplitViewController
    #elseif canImport(UIKit) && os(tvOS)
    typealias PlatformNavigationSplitView = UINavigationController
    #elseif canImport(AppKit)
    typealias PlatformNavigationSplitView = NSSplitView
    #endif

    func testNavigationSplitView() throws {
        guard #available(iOS 16, tvOS 16, macOS 13, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformNavigationSplitView.self) { spies in
            let spy = spies[0]

            NavigationSplitView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            } detail: {
                ZStack {
                    Color.red
                    Text("Detail")
                }
            }
            #if os(iOS)
            .introspect(.navigationSplitView, on: .iOS(.v16), customize: spy)
            #elseif os(tvOS)
            .introspect(.navigationSplitView, on: .tvOS(.v16), customize: spy)
            #elseif os(macOS)
            .introspect(.navigationSplitView, on: .macOS(.v13), customize: spy)
            #endif
        }
    }

    func testNavigationSplitViewAsAncestor() throws {
        guard #available(iOS 16, tvOS 16, macOS 13, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformNavigationSplitView.self) { spies in
            let spy = spies[0]

            // NB: columnVisibility is explicitly set here for ancestor introspection to work, because initially on iPad the sidebar is hidden, so the introspection modifier isn't triggered until the user makes the sidebar appear. This is why ancestor introspection is discouraged for most situations and it's opt-in.
            NavigationSplitView(columnVisibility: .constant(.all)) {
                ZStack {
                    Color.red
                    Text("Sidebar")
                        #if os(iOS)
                        .introspect(.navigationSplitView, on: .iOS(.v16), scope: .ancestor, customize: spy)
                        #elseif os(tvOS)
                        .introspect(.navigationSplitView, on: .tvOS(.v16), scope: .ancestor, customize: spy)
                        #elseif os(macOS)
                        .introspect(.navigationSplitView, on: .macOS(.v13), scope: .ancestor, customize: spy)
                        #endif
                }
            } detail: {
                Text("Detail")
            }
        }
    }
}
#endif
