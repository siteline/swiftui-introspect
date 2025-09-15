import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ProgressViewWithCircularStyleTests {
	#if canImport(UIKit)
	typealias PlatformProgressViewWithCircularStyle = UIActivityIndicatorView
	#elseif canImport(AppKit)
	typealias PlatformProgressViewWithCircularStyle = NSProgressIndicator
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformProgressViewWithCircularStyle.self) { spy1, spy2, spy3 in
			VStack {
				ProgressView(value: 0.25)
					.progressViewStyle(.circular)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				ProgressView(value: 0.5)
					.progressViewStyle(.circular)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				ProgressView(value: 0.75)
					.progressViewStyle(.circular)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.progressView(style: .circular), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.progressView(style: .circular), on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(AppKit) && !targetEnvironment(macCatalyst)
		#expect(entity1.doubleValue == 0.25)
		#expect(entity2.doubleValue == 0.5)
		#expect(entity3.doubleValue == 0.75)
		#endif
	}
}
