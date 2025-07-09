#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ButtonTests {
    #if canImport(AppKit)
    typealias PlatformButton = NSButton
    #endif

    @Test func introspect() async throws {
        let (entity1, entity2, entity3, entity4) = try await introspection(of: PlatformButton.self) { spy1, spy2, spy3, spy4 in
            VStack {
                Button("Button 0", action: {})
                    .buttonStyle(.bordered)
                    #if os(macOS)
                    .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
                    #endif

                Button("Button 1", action: {})
                    .buttonStyle(.borderless)
                    #if os(macOS)
                    .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
                    #endif

                Button("Button 2", action: {})
                    .buttonStyle(.link)
                    #if os(macOS)
                    .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
                    #endif

                Button("Button 3", action: {})
                    #if os(macOS)
                    .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy4)
                    #endif
            }
        }
        #if canImport(AppKit)
        #expect(Set([entity1, entity2, entity3, entity4].map(ObjectIdentifier.init)).count == 4)
        #endif
    }
}
#endif
