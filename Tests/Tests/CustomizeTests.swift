import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
struct CustomizeTests {
	#if canImport(UIKit)
	typealias PlatformScrollView = UIScrollView
	#elseif canImport(AppKit)
	typealias PlatformScrollView = NSScrollView
	#endif

	@Test func `customize runs the closure of a view re-created before its target is found`() async {
		let recorder = Recorder()
		TestUtils.present(view: Parent(recorder: recorder))

		let start = Date()
		while !recorder.customizedGenerations.contains(1), Date().timeIntervalSince(start) < 3 {
			await Task.yield()
		}
		#expect(recorder.customizedGenerations.last == 1)
	}

	@MainActor
	private final class Recorder {
		var customizedGenerations: [Int] = []
	}

	private struct Parent: View {
		@State var generation = 0
		let recorder: Recorder

		var body: some View {
			Child(generation: generation, recorder: recorder)
				.onAppear { generation += 1 }
		}
	}

	private struct Child: View {
		let generation: Int
		let recorder: Recorder

		var body: some View {
			ScrollView {
				Text("Generation \(generation)")
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(
				.scrollView,
				on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27),
				.tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26, .v27),
				.visionOS(.v1, .v2, .v26, .v27),
			) { _ in
				recorder.customizedGenerations.append(generation)
			}
			#elseif os(macOS)
			.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26, .v27)) { _ in
				recorder.customizedGenerations.append(generation)
			}
			#endif
		}
	}
}
