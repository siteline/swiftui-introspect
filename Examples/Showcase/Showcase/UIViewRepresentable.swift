import SwiftUI
@_spi(Internals) import SwiftUIIntrospect

struct UIViewRepresentableShowcase: View {
	let colors: [Color] = [.red, .green, .blue]

	var body: some View {
		VStack(spacing: 10) {
			ForEach(colors, id: \.self) { color in
				GenericViewRepresentable()
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.view,
						on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
					) { view in
						view.backgroundColor = UIColor(color)
					}
					#elseif os(macOS)
					.introspect(.view, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { view in
						view.layer?.backgroundColor = NSColor(color).cgColor
					}
					#endif
			}
		}
		.padding()
		#if os(iOS) || os(tvOS) || os(visionOS)
		.introspect(
			.view,
			on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
		) { view in
			view.backgroundColor = .red
		}
		#elseif os(macOS)
		.introspect(.view, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { view in
			view.layer?.backgroundColor = NSColor.red.cgColor
		}
		#endif
	}
}

@MainActor
struct GenericViewRepresentable: PlatformViewControllerRepresentable {
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
