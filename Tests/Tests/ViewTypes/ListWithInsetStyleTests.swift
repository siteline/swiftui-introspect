#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithInsetStyleTests {
	#if canImport(UIKit)
	typealias PlatformListWithInsetStyle = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformListWithInsetStyle = NSTableView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformListWithInsetStyle.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				.listStyle(.inset)
				#if os(iOS) || os(visionOS)
				.introspect(.list(style: .inset), on: .iOS(.v14, .v15), customize: spy1)
				.introspect(.list(style: .inset), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.list(style: .inset), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif

				List {
					Text("Item 1")
						#if os(iOS) || os(visionOS)
						.introspect(.list(style: .inset), on: .iOS(.v14, .v15), scope: .ancestor, customize: spy2)
						.introspect(.list(style: .inset), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.list(style: .inset), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
				.listStyle(.inset)
			}
		}
		#expect(entity1 !== entity2)
	}
}
#endif
