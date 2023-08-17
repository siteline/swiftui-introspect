#if !os(macOS) && !LEGACY_MACOS_SDK
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 14, tvOS 14, *)
final class PageControlTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformPageControl = UIPageControl
    #endif

    func testPageControl() throws {
        guard #available(iOS 14, tvOS 14, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformPageControl.self) { spies in
            let spy = spies[0]

            TabView {
                Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.pageControl, on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .visionOS(.v1), customize: spy)
            #endif
        }
    }
}
#endif
