import SwiftUI
import SwiftUIIntrospection
import XCTest

#if canImport(UIKit)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 3
    }

    static func present<ViewType: View>(view: ViewType) {

        let hostingController = UIHostingController(rootView: view)

        let application = UIApplication.shared
        application.windows.forEach { window in
            if let presentedViewController = window.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: nil)
            }
            window.isHidden = true
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.layer.speed = 10

        hostingController.beginAppearanceTransition(true, animated: false)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        hostingController.endAppearanceTransition()
    }
}
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 5
    }

    static func present<ViewType: View>(view: ViewType) {

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: true)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        window.layoutIfNeeded()
    }
}
#endif

#if os(macOS)
public typealias PlatformTextField = NSView
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformTextField = UIView
#endif

final class IntrospectTests: XCTestCase {
    func testTextField() throws {
        struct TextFieldTestView: View {
            let spy1: (PlatformTextField) -> Void
            let spy2: (PlatformTextField) -> Void
            let spy3: (PlatformTextField) -> Void
            @State private var textFieldValue = ""

            let textField1Placeholder = "Text Field 1"
            let textField2Placeholder = "Text Field 2"
            let textField3Placeholder = "Text Field 3"

            var body: some View {
                VStack {
                    #if os(iOS)
                    TextField(textField1Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                            self.spy1(textField)
                        }
                        .cornerRadius(8)
                    #elseif os(macOS)
                    TextField(textField1Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13), observing: ()) { textField, _ in
                            self.spy1(textField)
                        }
                        .cornerRadius(8)
                    #endif

                    #if os(iOS)
                    TextField(textField2Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                            self.spy2(textField)
                        }
                        .cornerRadius(8)
                    #elseif os(macOS)
                    TextField(textField3Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13), observing: ()) { textField, _ in
                            self.spy2(textField)
                        }
                        .cornerRadius(8)
                    #endif

                    #if os(iOS)
                    TextField(textField3Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                            self.spy3(textField)
                        }
                    #elseif os(macOS)
                    TextField(textField3Placeholder, text: $textFieldValue)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13), observing: ()) { textField, _ in
                            self.spy3(textField)
                        }
                    #endif
                }
            }
        }

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let expectation3 = XCTestExpectation()

        var textField1: PlatformTextField?
        var textField2: PlatformTextField?
        var textField3: PlatformTextField?

        let view = TextFieldTestView(
            spy1: {
                if let textField1 = textField1 {
                    XCTAssertIdentical(textField1, $0)
                }
                textField1 = $0
                expectation1.fulfill()
            },
            spy2: {
                if let textField2 = textField2 {
                    XCTAssertIdentical(textField2, $0)
                }
                textField2 = $0
                expectation2.fulfill()
            },
            spy3: {
                if let textField3 = textField3 {
                    XCTAssertIdentical(textField3, $0)
                }
                textField3 = $0
                expectation3.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2, expectation3], timeout: TestUtils.Constants.timeout)

        let unwrappedTextField1 = try XCTUnwrap(textField1)
        let unwrappedTextField2 = try XCTUnwrap(textField2)
        let unwrappedTextField3 = try XCTUnwrap(textField3)

//        XCTAssertEqual(unwrappedTextField1.placeholder, view.textField1Placeholder)
//        XCTAssertEqual(unwrappedTextField2.placeholder, view.textField2Placeholder)
//        XCTAssertEqual(unwrappedTextField3.placeholder, view.textField3Placeholder)
    }
}
