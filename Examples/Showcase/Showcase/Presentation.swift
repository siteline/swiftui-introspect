import SwiftUI
import SwiftUIIntrospect

#if !os(macOS)
struct PresentationShowcase: View {
	@State var isSheetPresented = false
	@State var isFullScreenPresented = false
	@State var isPopoverPresented = false

	var body: some View {
		VStack(spacing: 20) {
			Button("Sheet", action: { isSheetPresented = true })
				.sheet(isPresented: $isSheetPresented) {
					Button("Dismiss", action: { isSheetPresented = false })
						#if os(iOS) || os(tvOS)
						.introspect(
							.sheet,
							on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26)
						) { presentationController in
							presentationController.containerView?.backgroundColor = .red.withAlphaComponent(0.75)
						}
						#elseif os(visionOS)
						.introspect(.sheet, on: .visionOS(.v1, .v2, .v26)) { sheetPresentationController in
							sheetPresentationController.containerView?.backgroundColor = .red.withAlphaComponent(0.75)
						}
						#endif
				}

			Button("Full Screen Cover", action: { isFullScreenPresented = true })
				.fullScreenCover(isPresented: $isFullScreenPresented) {
					Button("Dismiss", action: { isFullScreenPresented = false })
						#if os(iOS) || os(tvOS) || os(visionOS)
						.introspect(
							.fullScreenCover,
							on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
						) { presentationController in
							presentationController.containerView?.backgroundColor = .red.withAlphaComponent(0.75)
						}
						#endif
				}

			#if os(iOS) || os(visionOS)
			Button("Popover", action: { isPopoverPresented = true })
				.popover(isPresented: $isPopoverPresented) {
					Button("Dismiss", action: { isPopoverPresented = false })
						.padding()
						.introspect(
							.popover,
							on: .iOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
						) { presentationController in
							presentationController.containerView?.backgroundColor = .red.withAlphaComponent(0.75)
						}
				}
			#endif
		}
	}
}
#endif
