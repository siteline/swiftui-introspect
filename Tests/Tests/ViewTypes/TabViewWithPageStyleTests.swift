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
                Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
            .tabViewStyle(.page)
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy)
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
                Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .visionOS(.v1), scope: .ancestor, customize: spy)
                    #endif
                Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
            .tabViewStyle(.page)
        }
    }
}
#endif
