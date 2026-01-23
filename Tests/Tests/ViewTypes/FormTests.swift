#if !os(macOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct FormTests {
	#if canImport(UIKit)
	typealias PlatformForm = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformForm = NSScrollView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformForm.self) { spy1, spy2 in
			HStack {
				Form {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.form, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
				.introspect(.form, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#endif

				Form {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.form, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						.introspect(.form, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
			}
		}
		#expect(entity1 !== entity2)
	}
}
#endif
