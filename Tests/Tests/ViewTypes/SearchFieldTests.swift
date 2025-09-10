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
    @Test(.disabledOn_iOS26_exceptFor_iPad())
    func introspectInNavigationStack() async throws {
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

    @available(iOS 26, tvOS 15, *)
    @Test func introspectInNavigationStackInTabView() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            TabView {
                NavigationView {
                    Text("Customized")
                        .searchable(text: .constant(""))
                }
                .navigationViewStyle(.stack)
            }
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
            #endif
        }
    }

    @available(iOS 15, tvOS 15, *)
    @Test(.disabledOn_iOS26_exceptFor_iPad())
    func introspectInNavigationStackAsAncestor() async throws {
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

    @available(iOS 26, tvOS 15, *)
    @Test func introspectInNavigationStackInTabViewAsAncestor() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            TabView {
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
    }

    @available(iOS 15, tvOS 15, *)
    @Test(.disabledOn_iOS26_exceptFor_iPad())
    func introspectInNavigationSplitView() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            NavigationView {
                Text("Customized")
                    .searchable(text: .constant(""))
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
            #endif
            #if os(iOS)
            // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
            .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
                $0.preferredDisplayMode = .oneOverSecondary
            }
            #endif
        }
    }

    @available(iOS 26, tvOS 15, *)
    @Test func introspectInNavigationSplitViewInTabView() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            TabView {
                NavigationView {
                    Text("Customized")
                        .searchable(text: .constant(""))
                }
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(.searchField, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
                #endif
                #if os(iOS)
                // NB: this is necessary for introspection to work, because on iPad the search field is in the sidebar, which is initially hidden.
                .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
                    $0.preferredDisplayMode = .oneOverSecondary
                }
                #endif
            }
        }
    }

    @available(iOS 15, tvOS 15, *)
    @Test(.disabledOn_iOS26_exceptFor_iPad())
    func introspectInNavigationSplitViewAsAncestor() async throws {
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

    @available(iOS 26, tvOS 15, *)
    @Test func introspectInNavigationSplitViewInTabViewAsAncestor() async throws {
        try await introspection(of: PlatformSearchField.self) { spy in
            TabView {
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
}

@MainActor
extension Trait where Self == ConditionTrait {
    // TODO: rename to `disabled on iOS 26+ except for iPad` when Swift 6.2 becomes available (on Xcode 26)
    static func disabledOn_iOS26_exceptFor_iPad(sourceLocation: SourceLocation = #_sourceLocation) -> Self {
        let disabled = if #available(iOS 26, *) {
            UIDevice.current.userInterfaceIdiom != .pad
        } else {
            false
        }
        return .disabled(if: disabled, "Disabled on iOS 26+ except for iPad", sourceLocation: sourceLocation)
    }
}
#endif
