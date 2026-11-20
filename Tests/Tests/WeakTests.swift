import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import Testing

@MainActor
struct WeakTests {
	final class Foo {}

	var strongFoo: Foo? = Foo()

	@Test func `init nil`() {
		@Weak var weakFoo: Foo?
		#expect(weakFoo == nil)
	}

	@Test func `init non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		#expect(weakFoo === strongFoo)
	}

	@Test func `assignment nil to nil`() {
		@Weak var weakFoo: Foo?
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func `assignment nil to non-nil`() {
		@Weak var weakFoo: Foo?
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test func `assignment non-nil to nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func `assignment non-nil to non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test mutating func `indirect assignment non-nil to nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = nil
		#expect(weakFoo == nil)
	}

	@Test mutating func `indirect assignment non-nil to non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = Foo()
		#expect(weakFoo == nil)
	}

	#if canImport(UIKit)
	typealias PlatformScrollView = UIScrollView
	#elseif canImport(AppKit)
	typealias PlatformScrollView = NSScrollView
	#endif

	@Test func `customize writes to the view re-created before its target is found`() async {
		let recorder = Recorder()
		TestUtils.present(view: Parent(recorder: recorder))

		let start = Date()
		while recorder.renderedScrollView?.wrappedValue == nil, Date().timeIntervalSince(start) < 3 {
			await Task.yield()
		}
		#expect(recorder.renderedScrollView?.wrappedValue != nil)
	}

	@MainActor
	private final class Recorder {
		var renderedScrollView: Weak<PlatformScrollView>? = nil
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
		@Weak var scrollView: PlatformScrollView?

		var body: some View {
			let _ = recorder.renderedScrollView = _scrollView
			ScrollView {
				Text("Generation \(generation)")
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(
				.scrollView,
				on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18),
				.tvOS(.v13, .v14, .v15, .v16, .v17, .v18),
				.visionOS(.v1, .v2),
			) {
				scrollView = $0
			}
			#elseif os(macOS)
			.introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
				scrollView = $0
			}
			#endif
		}
	}
}
