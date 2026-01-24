#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithGroupedStyleTests {
	typealias PlatformListWithGroupedStyle = UIScrollView // covers both UITableView and UICollectionView

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformListWithGroupedStyle.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				.listStyle(.grouped)
				.introspect(.list(style: .grouped), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
				.introspect(.list(style: .grouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)

				List {
					Text("Item 1")
						.introspect(.list(style: .grouped), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						.introspect(.list(style: .grouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
				}
				.listStyle(.grouped)
			}
		}
		#expect(entity1 !== entity2)
	}
}
#endif
