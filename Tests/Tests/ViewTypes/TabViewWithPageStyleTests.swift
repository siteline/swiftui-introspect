#if !os(macOS) && !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 14, tvOS 14, *)
final class TabViewWithPageStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformTabViewWithPageStyle = UICollectionView
    #endif

    func testTabViewWithPageStyle() throws {
        guard #available(iOS 14, tvOS 14, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformTabViewWithPageStyle.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            .tabViewStyle(.page)
            #if os(iOS) || os(tvOS)
            .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), customize: spy)
            #endif
        }
    }

    func testTabViewWithPageStyleAsAncestor() throws {
        guard #available(iOS 14, tvOS 14, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformTabViewWithPageStyle.self) { spies in
            let spy = spies[0]

            TabView {
                ZStack { Color.red; Text("1") }
                    #if os(iOS) || os(tvOS)
                    .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), scope: .ancestor, customize: spy)
                    #endif
                ZStack { Color.green; Text("2") }
            }
            .tabViewStyle(.page)
        }
    }
}
#endif
