#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite(.serialized)
struct TabViewWithPageStyleTests {
    #if canImport(UIKit)
    typealias PlatformTabViewWithPageStyle = UICollectionView
    #endif

    @Test func introspect() async throws {
        try await introspection(of: PlatformTabViewWithPageStyle.self) { spy in
            TabView {
                Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
            .tabViewStyle(.page)
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
            #endif
        }
    }

    @Test func introspectAsAncestor() async throws {
        try await introspection(of: PlatformTabViewWithPageStyle.self) { spy in
            TabView {
                Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy)
                    #endif
                Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
            }
            .tabViewStyle(.page)
        }
    }
}
#endif
