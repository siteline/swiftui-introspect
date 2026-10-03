import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
struct ProgressViewTests {
	#if canImport(UIKit)
	typealias PlatformProgressView = UIActivityIndicatorView
	#elseif canImport(AppKit)
	typealias PlatformProgressView = NSProgressIndicator
	#endif

	@Test func introspect() async throws {
		let (
			entity1,
			entity2,
			entity3,
		) = try await introspection(of: PlatformProgressView.self) { spy1, spy2, spy3 in
			VStack {
				ProgressView()
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.progressView,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.tvOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.visionOS(.v1, .v2, .v26, .v27),
						customize: spy1,
					)
					#elseif os(macOS)
					.introspect(
						.progressView,
						on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26, .v27),
						customize: spy1,
					)
					#endif

				ProgressView("Loading")
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.progressView,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.tvOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.visionOS(.v1, .v2, .v26, .v27),
						customize: spy2,
					)
					#elseif os(macOS)
					.introspect(
						.progressView,
						on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26, .v27),
						customize: spy2,
					)
					#endif

				ProgressView()
					.progressViewStyle(.automatic)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.progressView,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.tvOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27),
						.visionOS(.v1, .v2, .v26, .v27),
						customize: spy3,
					)
					#elseif os(macOS)
					.introspect(
						.progressView,
						on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26, .v27),
						customize: spy3,
					)
					#endif
			}
		}

		#expect(entity1 !== entity2)
		#expect(entity1 !== entity3)
		#expect(entity2 !== entity3)
		#if canImport(UIKit)
		#expect(entity1.isAnimating)
		#expect(entity2.isAnimating)
		#expect(entity3.isAnimating)
		#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
		#expect(entity1.isIndeterminate)
		#expect(entity2.isIndeterminate)
		#expect(entity3.isIndeterminate)
		#endif
	}
}
