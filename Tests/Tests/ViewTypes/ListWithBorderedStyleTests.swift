#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithBorderedStyleTests {
    #if canImport(AppKit)
    typealias PlatformListWithBorderedStyle = NSTableView
    #endif

    @available(macOS 12, *)
    @Test func introspect() async throws {
        let (entity1, entity2) = try await introspection(of: PlatformListWithBorderedStyle.self) { spy1, spy2 in
            HStack {
                List {
                    Text("Item 1")
                }
                .listStyle(.bordered)
                #if os(macOS)
                .introspect(.list(style: .bordered), on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy1)
                #endif

                List {
                    Text("Item 1")
                    #if os(macOS)
                    .introspect(.list(style: .bordered), on: .macOS(.v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
                    #endif
                }
                .listStyle(.bordered)
            }
        }
        #expect(entity1 !== entity2)
    }
}
#endif
