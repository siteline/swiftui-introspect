#if !os(macOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct SearchFieldTests {
    #if canImport(UIKit)
    typealias PlatformSearchField = UISearchBar
    #endif

    @available(iOS 15, tvOS 15, *)
    @Test func introspectInNavigationStack() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
            }
            .navigationViewStyle(.stack)
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
            #endif
        }
    }

    @available(iOS 15, tvOS 15, *)
    @Test func introspectInNavigationStackAsAncestor() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(.stack)
        }
    }

    @available(iOS 15, tvOS 15, *)
    @available(visionOS, introduced: 1, obsoleted: 26)
    @Test func introspectInNavigationSplitView() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2), customize: spy)
            #endif
            #if os(iOS)
            // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
            .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
                $0.preferredDisplayMode = .oneOverSecondary
            }
            #endif
        }
    }

    @available(iOS 15, tvOS 15, *)
    @Test func introspectInNavigationSplitViewAsAncestor() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
                    #endif
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS)
            // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
            .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
                $0.preferredDisplayMode = .oneOverSecondary
            }
            #endif
        }
    }
}
#endif
