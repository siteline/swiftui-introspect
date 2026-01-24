import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct FormWithGroupedStyleTests {
	#if canImport(UIKit)
	typealias PlatformFormWithGroupedStyle = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformFormWithGroupedStyle = NSScrollView
	#endif

	@available(iOS 16, tvOS 16, macOS 13, *)
	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformFormWithGroupedStyle.self) { spy1, spy2 in
			HStack {
				Form {
					Text("Item 1")
				}
				.formStyle(.grouped)
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.form(style: .grouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				.introspect(.form(style: .grouped), on: .tvOS(.v16, .v17, .v18, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.form(style: .grouped), on: .macOS(.v13, .v14, .v15, .v26), customize: spy1)
				#endif

				Form {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.form(style: .grouped), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						.introspect(.form(style: .grouped), on: .tvOS(.v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.form(style: .grouped), on: .macOS(.v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
				.formStyle(.grouped)
			}
		}
		#expect(entity1 !== entity2)
	}
}
