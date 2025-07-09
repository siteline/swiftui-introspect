#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ToggleWithCheckboxStyleTests {
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    typealias PlatformToggleWithCheckboxStyle = NSButton
    #endif

    @Test func testToggleWithCheckboxStyle() async throws {
        let (entity1, entity2, entity3) = try await introspection(of: PlatformToggleWithCheckboxStyle.self) { spy1, spy2, spy3 in
            VStack {
                Toggle("", isOn: .constant(true))
                    .toggleStyle(.checkbox)
                    #if os(macOS)
                    .introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
                    #endif

                Toggle("", isOn: .constant(false))
                    .toggleStyle(.checkbox)
                    #if os(macOS)
                    .introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
                    #endif

                Toggle("", isOn: .constant(true))
                    .toggleStyle(.checkbox)
                    #if os(macOS)
                    .introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
                    #endif
            }
        }
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        #expect(entity1.state == .on)
        #expect(entity2.state == .off)
        #expect(entity3.state == .on)
        #endif
    }
}
#endif
