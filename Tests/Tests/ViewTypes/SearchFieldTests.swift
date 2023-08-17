#if !os(macOS)
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
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17), .tvOS(.v15, .v16, .v17), .visionOS(.v1), customize: spy)
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
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16, .v17), .tvOS(.v15, .v16, .v17), .visionOS(.v1), scope: .ancestor, customize: spy)
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
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17), .tvOS(.v15, .v16, .v17), .visionOS(.v1), customize: spy)
            #endif
            #if os(iOS)
            // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
            .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
                $0.preferredDisplayMode = .oneOverSecondary
            }
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
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16, .v17), .tvOS(.v15, .v16, .v17), .visionOS(.v1), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS)
            // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
            .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
                $0.preferredDisplayMode = .oneOverSecondary
            }
            #endif
        }
    }
}
#endif
