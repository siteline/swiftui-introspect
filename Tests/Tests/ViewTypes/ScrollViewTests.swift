import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ScrollViewTests {
	#if canImport(UIKit)
	typealias PlatformScrollView = UIScrollView
	#elseif canImport(AppKit)
	typealias PlatformScrollView = NSScrollView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformScrollView.self) { spy1, spy2 in
			HStack {
				ScrollView(showsIndicators: false) {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif

				ScrollView(showsIndicators: true) {
					Text("Item 1")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
					#elseif os(macOS)
					.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
					#endif
				}
			}
		}
		#if canImport(UIKit)
		#expect(entity1.showsVerticalScrollIndicator == false)
		#expect(entity2.showsVerticalScrollIndicator == true)
		#elseif canImport(AppKit)
		#expect(entity1.verticalScroller == nil)
		#expect(entity2.verticalScroller != nil)
		#endif

		#expect(entity1 !== entity2)
	}

	@Test func introspectOnFuturePlatformVersions() async throws {
		let entity = try await introspection(of: PlatformScrollView.self) { spy in
			ScrollView(showsIndicators: false) {
				Text("Item 1")
			}
			#if canImport(UIKit)
			.introspect(.scrollView, on: .iOS(.v13...), .tvOS(.v13...), .visionOS(.v1...), customize: spy)
			#elseif canImport(AppKit)
			.introspect(.scrollView, on: .macOS(.v10_15...), customize: spy)
			#endif
		}
		#if canImport(UIKit)
		#expect(entity.showsVerticalScrollIndicator == false)
		#expect(entity.showsHorizontalScrollIndicator == false)
		#elseif canImport(AppKit)
		#expect(entity.verticalScroller == nil)
		#expect(entity.horizontalScroller == nil)
		#endif
	}

	@Test func introspectNested() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformScrollView.self) { spy1, spy2 in
			ScrollView(showsIndicators: true) {
				Text("Item 1")

				ScrollView(showsIndicators: false) {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
				#elseif os(macOS)
				.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
				#endif
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
			#elseif os(macOS)
			.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
			#endif
		}
		#if canImport(UIKit)
		#expect(entity1.showsVerticalScrollIndicator == true)
		#expect(entity2.showsVerticalScrollIndicator == false)
		#elseif canImport(AppKit)
		#expect(entity1.verticalScroller != nil)
		#expect(entity2.verticalScroller == nil)
		#endif

		#expect(entity1 !== entity2)
	}

	@Test func introspectMasked() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformScrollView.self) { spy1, spy2 in
			HStack {
				ScrollView(showsIndicators: false) {
					Text("Item 1")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif
				.clipped()
				.clipShape(RoundedRectangle(cornerRadius: 20.0))
				.cornerRadius(2.0)

				ScrollView(showsIndicators: true) {
					Text("Item 1")
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor, customize: spy2)
						#elseif os(macOS)
						.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor, customize: spy2)
						#endif
				}
			}
		}
		#if canImport(UIKit)
		#expect(entity1.showsVerticalScrollIndicator == false)
		#expect(entity2.showsVerticalScrollIndicator == true)
		#elseif canImport(AppKit)
		#expect(entity1.verticalScroller == nil)
		#expect(entity2.verticalScroller != nil)
		#endif

		#expect(entity1 !== entity2)
	}
}
