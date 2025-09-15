import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PickerWithSegmentedStyleTests {
	#if canImport(UIKit)
	typealias PlatformPickerWithSegmentedStyle = UISegmentedControl
	#elseif canImport(AppKit)
	typealias PlatformPickerWithSegmentedStyle = NSSegmentedControl
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformPickerWithSegmentedStyle.self) { spy1, spy2, spy3 in
			VStack {
				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
				}
				.pickerStyle(.segmented)
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
				#elseif os(macOS)
				.introspect(.picker(style: .segmented), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
				#endif
				.cornerRadius(8)

				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
					Text("2").tag("2")
				}
				.pickerStyle(.segmented)
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
				#elseif os(macOS)
				.introspect(.picker(style: .segmented), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
				#endif
				.cornerRadius(8)

				Picker("Pick", selection: .constant("1")) {
					Text("1").tag("1")
					Text("2").tag("2")
					Text("3").tag("3")
				}
				.pickerStyle(.segmented)
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(.picker(style: .segmented), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
				#elseif os(macOS)
				.introspect(.picker(style: .segmented), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
				#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.numberOfSegments == 1)
		#expect(entity2.numberOfSegments == 2)
		#expect(entity3.numberOfSegments == 3)
		#elseif canImport(AppKit)
		#expect(entity1.segmentCount == 1)
		#expect(entity2.segmentCount == 2)
		#expect(entity3.segmentCount == 3)
		#endif
	}
}
