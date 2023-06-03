#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 15, tvOS 15, *)
final class SearchFieldTests: XCTestCase {
    #if canImport(UIKit) && os(iOS)
    typealias PlatformSearchField = UISearchController
    #elseif canImport(UIKit) && os(tvOS)
    typealias PlatformSearchField = UISearchBar
    #endif

    func testSearchField() throws {
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
            #if os(iOS)
            .introspect(.searchField, on: .iOS(.v15, .v16), customize: spy)
            #elseif os(tvOS)
            .introspect(.searchField, on: .tvOS(.v15, .v16), customize: spy)
            #endif
        }
    }

    func testSearchFieldAsAncestor() throws {
        guard #available(iOS 15, tvOS 15, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSearchField.self) { spies in
            let spy = spies[0]

            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
                    #if os(iOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16), scope: .ancestor, customize: spy)
                    #elseif os(tvOS)
                    .introspect(.searchField, on: .tvOS(.v15, .v16), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif
