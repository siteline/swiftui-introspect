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
		await poll { entity != nil }
		#expect(entity != nil)
	}

	@Test func `introspection finds a replaced receiver rather than an ancestor`() async throws {
		let model = ReplacementModel()
		weak var original: PlatformScrollView?
		var replacement: PlatformScrollView?
		var customizedAncestor = false
		TestUtils.present(
			view: ScrollView {
				ReplaceableScrollView(model: model) { entity in
					guard Self.isNested(entity) else {
						customizedAncestor = true
						return
					}
					if model.isReplaced, entity !== original {
						replacement = entity
					} else if original == nil {
						original = entity
					}
				}
			},
		)
		await poll { original != nil }
		try #require(original != nil)
		try await Task.sleep(nanoseconds: 300_000_000)

		model.isReplaced = true
		try await Task.sleep(nanoseconds: 300_000_000)
		// Updates the modifier once the original receiver is gone.
		model.revision += 1
		await poll { replacement != nil }

		#expect(replacement != nil)
		#expect(!customizedAncestor)
	}

	/// Whether the scroll view sits inside another one.
	private static func isNested(_ scrollView: PlatformScrollView) -> Bool {
		var view = scrollView.superview
		while let superview = view {
			if superview is PlatformScrollView {
				return true
			}
			view = superview.superview
		}
		return false
	}

	private final class ReplacementModel: ObservableObject {
		@Published var isReplaced = false
		@Published var revision = 0
	}

	/// A scroll view, introspected in both scopes, that SwiftUI replaces with another one when the model says so.
	private struct ReplaceableScrollView: View {
		@ObservedObject var model: ReplacementModel
		let spy: (PlatformScrollView) -> Void

		var body: some View {
			Group {
				if model.isReplaced {
					ScrollView { Text("Replacement \(model.revision)") }
				} else {
					ScrollView { Text("Original \(model.revision)") }
				}
			}
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(
				.scrollView,
				on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18),
				.tvOS(.v13, .v14, .v15, .v16, .v17, .v18),
				.visionOS(.v1, .v2),
				scope: [.receiver, .ancestor],
				customize: spy,
			)
			#elseif os(macOS)
			.introspect(
				.scrollView,
				on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15),
				scope: [.receiver, .ancestor],
				customize: spy,
			)
			#endif
		}
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
					on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18),
					.tvOS(.v13, .v14, .v15, .v16, .v17, .v18),
					.visionOS(.v1, .v2),
					scope: model.scope,
					customize: spy,
				)
				#elseif os(macOS)
				.introspect(
					.scrollView,
					on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15),
					scope: model.scope,
					customize: spy,
				)
				#endif
			}
		}
	}
}
