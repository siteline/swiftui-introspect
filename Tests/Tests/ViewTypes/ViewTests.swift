import SwiftUI
@testable import SwiftUIIntrospect
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
