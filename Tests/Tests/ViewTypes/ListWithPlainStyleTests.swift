import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListWithPlainStyleTests {
	#if canImport(UIKit)
	typealias PlatformListWithPlainStyle = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformListWithPlainStyle = NSTableView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformListWithPlainStyle.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				.listStyle(.plain)
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.list(style: .plain), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
				.introspect(.list(style: .plain), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.list(style: .plain), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif

				List {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.list(style: .plain), on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						.introspect(.list(style: .plain), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.list(style: .plain), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
				.listStyle(.plain)
			}
		}
		#expect(entity1 !== entity2)
	}
}
