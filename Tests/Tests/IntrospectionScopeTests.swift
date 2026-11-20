import Combine
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
struct IntrospectionScopeTests {
	#if canImport(UIKit)
	typealias PlatformScrollView = UIScrollView
	#elseif canImport(AppKit)
	typealias PlatformScrollView = NSScrollView
	#endif

	@Test func `introspection finds the receiver once its scope changes to include it`() async throws {
		let model = ScopeModel()
		var entity: PlatformScrollView?
		TestUtils.present(view: ScopedScrollView(model: model) { entity = $0 })
		try await Task.sleep(nanoseconds: 300_000_000)
		#expect(entity == nil)

		model.scope = .receiver
		let start = Date()
		while entity == nil, Date().timeIntervalSince(start) < 3 {
			await Task.yield()
		}
		#expect(entity != nil)
	}

	private final class ScopeModel: ObservableObject {
		@Published var scope: IntrospectionScope = .ancestor
	}

	private struct ScopedScrollView: View {
		@ObservedObject var model: ScopeModel
		let spy: (PlatformScrollView) -> Void

		var body: some View {
			VStack {
				Text("Header")
				ScrollView {
					Text("Item")
				}
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(
					.scrollView,
					on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26),
					.tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26),
					.visionOS(.v1, .v2, .v26),
					scope: model.scope,
					customize: spy,
				)
				#elseif os(macOS)
				.introspect(
					.scrollView,
					on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26),
					scope: model.scope,
					customize: spy,
				)
				#endif
			}
		}
	}
}
