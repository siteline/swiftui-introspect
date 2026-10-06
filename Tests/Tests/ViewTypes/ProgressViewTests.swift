import SwiftUI
import SwiftUIIntrospect
import XCTest

@MainActor
final class ProgressViewTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformProgressView = UIActivityIndicatorView
    #elseif canImport(AppKit)
    typealias PlatformProgressView = NSProgressIndicator
    #endif

    func testProgressView() throws {
        guard #available(iOS 14, tvOS 14, macOS 11, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformProgressView.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                ProgressView()
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.progressView, on: .iOS(.v14, .v15, .v16, .v17, .v18), .tvOS(.v14, .v15, .v16, .v17, .v18), .visionOS(.v1, .v2), customize: spy0)
                    #elseif os(macOS)
                    .introspect(.progressView, on: .macOS(.v11, .v12, .v13, .v14, .v15), customize: spy0)
                    #endif

                ProgressView("Loading")
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.progressView, on: .iOS(.v14, .v15, .v16, .v17, .v18), .tvOS(.v14, .v15, .v16, .v17, .v18), .visionOS(.v1, .v2), customize: spy1)
                    #elseif os(macOS)
                    .introspect(.progressView, on: .macOS(.v11, .v12, .v13, .v14, .v15), customize: spy1)
                    #endif

                ProgressView()
                    .progressViewStyle(.automatic)
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(.progressView, on: .iOS(.v14, .v15, .v16, .v17, .v18), .tvOS(.v14, .v15, .v16, .v17, .v18), .visionOS(.v1, .v2), customize: spy2)
                    #elseif os(macOS)
                    .introspect(.progressView, on: .macOS(.v11, .v12, .v13, .v14, .v15), customize: spy2)
                    #endif
            }
        } extraAssertions: { entities in
            XCTAssertEqual(entities.count, 3)
            guard entities.count == 3 else { return }
            let entity1 = entities[0]
            let entity2 = entities[1]
            let entity3 = entities[2]

            XCTAssertFalse(entity1 === entity2)
            XCTAssertFalse(entity1 === entity3)
            XCTAssertFalse(entity2 === entity3)
            #if canImport(UIKit)
            XCTAssertTrue(entity1.isAnimating)
            XCTAssertTrue(entity2.isAnimating)
            XCTAssertTrue(entity3.isAnimating)
            #elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
            XCTAssertTrue(entity1.isIndeterminate)
            XCTAssertTrue(entity2.isIndeterminate)
            XCTAssertTrue(entity3.isIndeterminate)
            #endif
        }
    }
}
