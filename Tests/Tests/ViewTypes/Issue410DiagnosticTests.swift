#if canImport(UIKit) && os(iOS)
import SwiftUI
import SwiftUIIntrospect
import Testing
import UIKit

@MainActor
struct Issue410DiagnosticTests {
	@Test func `removing the collection view's gesture recognizers detaches every pan`() async throws {
		var customizeCount = 0
		let collectionView = try await introspection(of: UICollectionView.self) { spy in
			pages.introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27)) {
				customizeCount += 1
				log("customize #\(customizeCount)", $0)
				$0.gestureRecognizers?.removeAll()
				spy($0)
			}
		}
		try await Task.sleep(nanoseconds: 1_000_000_000)

		print("[410] after 1s: customizeCount=\(customizeCount)")
		log("after 1s", collectionView)
		print("[410] hierarchy:\n\(collectionView.value(forKey: "recursiveDescription") ?? "")")
		#expect(collectionView.panGestureRecognizer.view == nil)
		#expect(Self.scrollViews(in: collectionView)
			.allSatisfy { $0.panGestureRecognizer.view == nil || !$0.isScrollEnabled })
	}

	@Test func `disabling nested embedded scroll views in customize`() async throws {
		let collectionView = try await introspection(of: UICollectionView.self) { spy in
			pages.introspect(.tabView(style: .page), on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26, .v27)) {
				let embedded = $0.subviews
					.compactMap { $0 as? UIScrollView }
					.filter { NSStringFromClass(type(of: $0)).contains("EmbeddedScrollView") }
				print("[410] workaround customize: embedded scroll views present=\(embedded.count)")
				$0.isScrollEnabled = false
				embedded.forEach { $0.isScrollEnabled = false }
				spy($0)
			}
		}
		try await Task.sleep(nanoseconds: 1_000_000_000)

		log("workaround after 1s", collectionView)
		#expect(Self.scrollViews(in: collectionView).allSatisfy { !$0.isScrollEnabled })
	}

	private var pages: some View {
		TabView {
			Text("Page 1").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red)
			Text("Page 2").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.blue)
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
	}

	private func log(_ label: String, _ collectionView: UICollectionView) {
		print(
			"[410] \(label): \(type(of: collectionView)) scrollEnabled=\(collectionView.isScrollEnabled) paging=\(collectionView.isPagingEnabled) contentSize=\(collectionView.contentSize) subviews=\(collectionView.subviews.map { type(of: $0) }) recognizers=\((collectionView.gestureRecognizers ?? []).map { type(of: $0) })",
		)
		for scrollView in Self.scrollViews(in: collectionView) {
			print(
				"[410] \(label): nested \(type(of: scrollView)) superview=\(scrollView.superview.map { type(of: $0) } as Any) scrollEnabled=\(scrollView.isScrollEnabled) paging=\(scrollView.isPagingEnabled) contentSize=\(scrollView.contentSize) recognizers=\((scrollView.gestureRecognizers ?? []).map { type(of: $0) })",
			)
		}
	}

	private static func scrollViews(in view: UIView) -> [UIScrollView] {
		view.subviews.flatMap { subview in
			((subview as? UIScrollView).map { [$0] } ?? []) + scrollViews(in: subview)
		}
	}
}
#endif
