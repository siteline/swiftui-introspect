import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListTests {
	#if canImport(UIKit)
	typealias PlatformList = UIScrollView // covers both UITableView and UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformList = NSTableView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformList.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
				.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif

				List {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
			}
		}
		#expect(entity1 !== entity2)
	}

	#if !os(macOS)
	@Test func introspectNested() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformList.self) { spy1, spy2 in
			List {
				Text("Item 1")

				List {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy2)
				.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
				#endif
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
			.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
			#endif
		}
		#expect(entity1 !== entity2)
	}
	#endif

	@Test func introspectMasked() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformList.self) { spy1, spy2 in
			HStack {
				List {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
				.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif
				.clipped()
				.clipShape(RoundedRectangle(cornerRadius: 20.0))
				.cornerRadius(2.0)

				List {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor, customize: spy2)
						.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
			}
		}
		#expect(entity1 !== entity2)
	}
}
