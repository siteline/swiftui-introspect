#if !os(iOS) && !os(tvOS) && !os(visionOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PickerWithMenuStyleTests {
    #if canImport(AppKit) && !targetEnvironment(macCatalyst)
    typealias PlatformPickerWithMenuStyle = NSPopUpButton
    #endif

    @Test func introspect() async throws {
        let (entity1, entity2, entity3) = try await introspection(of: PlatformPickerWithMenuStyle.self) { spy1, spy2, spy3 in
            VStack {
                Picker("Pick", selection: .constant("1")) {
                    Text("1").tag("1")
                }
                .pickerStyle(.menu)
                #if os(macOS)
                .introspect(.picker(style: .menu), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
                #endif
                .cornerRadius(8)

                Picker("Pick", selection: .constant("1")) {
                    Text("1").tag("1")
                    Text("2").tag("2")
                }
                .pickerStyle(.menu)
                #if os(macOS)
                .introspect(.picker(style: .menu), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
                #endif
                .cornerRadius(8)

                Picker("Pick", selection: .constant("1")) {
                    Text("1").tag("1")
                    Text("2").tag("2")
                    Text("3").tag("3")
                }
                .pickerStyle(.menu)
                #if os(macOS)
                .introspect(.picker(style: .menu), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
                #endif
            }
        }
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        #expect(entity1.numberOfItems == 1)
        #expect(entity2.numberOfItems == 2)
        #expect(entity3.numberOfItems == 3)
        #endif
    }
}
#endif
