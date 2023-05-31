import SwiftUI
import SwiftUIIntrospect
import XCTest

final class ListWithPlainStyleTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformListWithPlainStyle = UIScrollView // covers both UITableView and UICollectionView
    #elseif canImport(AppKit)
    typealias PlatformListWithPlainStyle = NSTableView
    #endif

    func testListWithPlainStyle() {
        XCTAssertViewIntrospection(of: PlatformListWithPlainStyle.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]

            HStack {
                List {
                    Text("Item 1")
                }
                .listStyle(.plain)
                #if os(iOS) || os(tvOS)
                .introspect(.list(style: .plain), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16)) { spy0($0) }
                .introspect(.list(style: .plain), on: .iOS(.v16)) { spy0($0) }
                #elseif os(macOS)
                .introspect(.list(style: .plain), on: .macOS(.v10_15, .v11, .v12, .v13)) { spy0($0) }
                #endif

                List {
                    Text("Item 1")
                    Text("Item 2")
                    #if os(iOS) || os(tvOS)
                    .introspect(.list(style: .plain), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16), scope: .ancestor) { spy1($0) }
                    .introspect(.list(style: .plain), on: .iOS(.v16), scope: .ancestor) { spy1($0) }
                    #elseif os(macOS)
                    .introspect(.list(style: .plain), on: .macOS(.v10_15, .v11, .v12, .v13), scope: .ancestor) { spy1($0) }
                    #endif
                }
                .listStyle(.plain)
            }
        } extraAssertions: {
            XCTAssert($0[safe: 0] !== $0[safe: 1])
        }
    }
}
