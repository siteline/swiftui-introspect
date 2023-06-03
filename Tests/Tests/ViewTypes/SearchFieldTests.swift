#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 15, tvOS 15, *)
final class SearchFieldTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformSearchField = UISearchBar
    #endif

    func testSearchFieldInNavigationStack() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSearchField.self) { spies in
            let spy = spies[0]

            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
            }
            .navigationViewStyle(.stack)
            #if os(iOS) || os(tvOS)
            .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16), customize: spy)
            #endif
        }
    }

    func testSearchFieldInNavigationStackAsAncestor() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSearchField.self) { spies in
            let spy = spies[0]

            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
                    #if os(iOS) || os(tvOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(.stack)
        }
    }

    func testSearchFieldInNavigationSplitView() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSearchField.self) { spies in
            let spy = spies[0]

            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS) || os(tvOS)
            .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16), customize: spy)
            #endif
        }
    }

    func testSearchFieldInNavigationSplitViewAsAncestor() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSearchField.self) { spies in
            let spy = spies[0]

            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
                    #if os(iOS) || os(tvOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}
#endif
