#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ToggleWithButtonStyleTests {
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    typealias PlatformToggleWithButtonStyle = NSButton
    #endif

    @available(macOS 12, *)
    @Test func introspect() async throws {
        let (entity1, entity2, entity3) = try await introspection(of: PlatformToggleWithButtonStyle.self) { spy1, spy2, spy3 in
            VStack {
                Toggle("", isOn: .constant(true))
                    .toggleStyle(.button)
                    #if os(macOS)
                    .introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy1)
                    #endif

                Toggle("", isOn: .constant(false))
                    .toggleStyle(.button)
                    #if os(macOS)
                    .introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy2)
                    #endif

                Toggle("", isOn: .constant(true))
                    .toggleStyle(.button)
                    #if os(macOS)
                    .introspect(.toggle(style: .button), on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy3)
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
