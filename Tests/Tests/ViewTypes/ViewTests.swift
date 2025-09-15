import SwiftUI
@_spi(Internals) import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct ViewTests {
	@Test func introspect() async throws {
		let (entity1, entity2) = try await introspection(of: PlatformView.self) { spy1, spy2 in
			VStack(spacing: 10) {
				SUTView().frame(height: 30)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				SUTView().frame(height: 40)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
			}
			.padding(10)
		}
		#expect(entity1.frame.height == 30)
		#expect(entity2.frame.height == 40)
	}
}

struct SUTView: PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias UIViewControllerType = PlatformViewController
	#elseif canImport(AppKit)
	typealias NSViewControllerType = PlatformViewController
	#endif

	func makePlatformViewController(context: Context) -> PlatformViewController {
		let controller = PlatformViewController(nibName: nil, bundle: nil)
		controller.view.translatesAutoresizingMaskIntoConstraints = false

		let widthConstraint = controller.view.widthAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
		widthConstraint.priority = .defaultLow

		let heightConstraint = controller.view.heightAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
		heightConstraint.priority = .defaultLow

		NSLayoutConstraint.activate([widthConstraint, heightConstraint])

		return controller
	}

	func updatePlatformViewController(_ controller: PlatformViewController, context: Context) {
		// NO-OP
	}

	static func dismantlePlatformViewController(_ controller: PlatformViewController, coordinator: Coordinator) {
		// NO-OP
	}
}
