#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithSidebarStyleTests {
	#if canImport(UIKit)
	typealias PlatformListWithSidebarStyle = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformListWithSidebarStyle = NSTableView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformListWithSidebarStyle.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				.listStyle(.sidebar)
				#if os(iOS) || os(visionOS)
				.introspect(.list(style: .sidebar), on: .iOS(.v14, .v15), customize: spy1)
				.introspect(.list(style: .sidebar), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.list(style: .sidebar), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif

				List {
					Text("Item 1")
						#if os(iOS) || os(visionOS)
						.introspect(.list(style: .sidebar), on: .iOS(.v14, .v15), scope: .ancestor, customize: spy2)
						.introspect(.list(style: .sidebar), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.list(style: .sidebar), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
				.listStyle(.sidebar)
			}
		}
		#expect(entity1 !== entity2)
	}
}
#endif
