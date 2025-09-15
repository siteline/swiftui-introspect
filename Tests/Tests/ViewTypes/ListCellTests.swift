import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ListCellTests {
	#if canImport(UIKit)
	typealias PlatformListCell = UIView // covers both UITableViewCell and UICollectionViewCell
	#elseif canImport(AppKit)
	typealias PlatformListCell = NSTableCellView
	#endif

	@Test func introspect() async throws {
		try await introspection(of: PlatformListCell.self) { spy in
			List {
				Text("Item 1")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.listCell, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy)
					.introspect(.listCell, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
					#elseif os(macOS)
					.introspect(.listCell, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy)
					#endif
			}
		}
	}

	@Test func introspectMasked() async throws {
		try await introspection(of: PlatformListCell.self) { spy in
			List {
				Text("Item 1")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.listCell, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy)
					.introspect(.listCell, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy)
					#elseif os(macOS)
					.introspect(.listCell, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy)
					#endif
					.clipped()
					.clipShape(RoundedRectangle(cornerRadius: 20.0))
					.cornerRadius(2.0)
			}
		}
	}
}
