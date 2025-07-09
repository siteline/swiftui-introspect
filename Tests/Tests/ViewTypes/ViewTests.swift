import SwiftUI
import SwiftUIIntrospect
import XCTest

@MainActor
final class ViewTests: XCTestCase {
    func testView() {
        XCTAssertViewIntrospection(of: PlatformView.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]

            VStack(spacing: 10) {
                SUTView().frame(height: 30)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy0)
                    #elseif os(macOS)
                    .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy0)
                    #endif

                SUTView().frame(height: 40)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
                    #elseif os(macOS)
                    .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
                    #endif
            }
            .padding(10)
        } extraAssertions: {
            XCTAssertEqual($0[safe: 0]?.frame.height, 30)
            XCTAssertEqual($0[safe: 1]?.frame.height, 40)
        }
    }
}

struct SUTView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
        widthConstraint.priority = .defaultLow

        let heightConstraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
        heightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([widthConstraint, heightConstraint])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // NO-OP
    }
}
