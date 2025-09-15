#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TableTests {
	#if canImport(UIKit)
	typealias PlatformTable = UICollectionView
	#elseif canImport(AppKit)
	typealias PlatformTable = NSTableView
	#endif

	@available(iOS 16, macOS 12, *)
	@Test func introspect() async throws {
		try await introspection(of: PlatformTable.self) { spy1, spy2, spy3 in
			VStack {
				TipTable()
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				TipTable()
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				TipTable()
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
	}

	@available(iOS 16, macOS 12, *)
	@Test func introspectWithInsetStyle() async throws {
		try await introspection(of: PlatformTable.self) { spy1, spy2, spy3 in
			VStack {
				TipTable()
					.tableStyle(.inset)
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				TipTable()
					.tableStyle(.inset)
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				TipTable()
					.tableStyle(.inset)
					#if os(iOS) || os(visionOS)
					.introspect(.table, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
	}

	#if os(macOS)
	@available(macOS 12, *)
	@Test func introspectWithBorderedStyle() async throws {
		try await introspection(of: PlatformTable.self) { spy1, spy2, spy3 in
			VStack {
				TipTable()
					.tableStyle(.bordered)
					#if os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				TipTable()
					.tableStyle(.bordered)
					#if os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				TipTable()
					.tableStyle(.bordered)
					#if os(macOS)
					.introspect(.table, on: .macOS(.v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
	}
	#endif
}

@available(iOS 16, macOS 12, *)
extension TableTests {
	struct TipTable: View {
		struct Purchase: Identifiable {
			let price: Decimal
			let id = UUID()
		}

		var body: some View {
			Table(of: Purchase.self) {
				TableColumn("Base price") { purchase in
					Text(purchase.price, format: .currency(code: "USD"))
				}
				TableColumn("With 15% tip") { purchase in
					Text(purchase.price * 1.15, format: .currency(code: "USD"))
				}
				TableColumn("With 20% tip") { purchase in
					Text(purchase.price * 1.2, format: .currency(code: "USD"))
				}
				TableColumn("With 25% tip") { purchase in
					Text(purchase.price * 1.25, format: .currency(code: "USD"))
				}
			} rows: {
				TableRow(Purchase(price: 20))
				TableRow(Purchase(price: 50))
				TableRow(Purchase(price: 75))
			}
		}
	}
}
#endif
