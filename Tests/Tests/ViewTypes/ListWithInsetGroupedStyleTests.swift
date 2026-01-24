#if !os(tvOS) && !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithInsetGroupedStyleTests {
	typealias PlatformListWithInsetGroupedStyle = UIScrollView // covers both UITableView and UICollectionView

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformListWithInsetGroupedStyle.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				.listStyle(.insetGrouped)
				.introspect(.list(style: .insetGrouped), on: .iOS(.v14, .v15), customize: spy1)
				.introspect(.list(style: .insetGrouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)

				List {
					Text("Item 1")
						.introspect(.list(style: .insetGrouped), on: .iOS(.v14, .v15), scope: .ancestor, customize: spy2)
						.introspect(.list(style: .insetGrouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
				}
				.listStyle(.insetGrouped)
			}
		}
		#expect(entity1 !== entity2)
	}
}
#endif
