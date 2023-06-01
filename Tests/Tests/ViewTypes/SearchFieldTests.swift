#if os(iOS) || os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 15, tvOS 15, *)
final class SearchFieldTests: XCTestCase {
    #if canImport(UIKit)
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
            #if os(iOS) || os(tvOS)
            .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16), customize: spy)
            #endif
        }
    }
}
#endif
