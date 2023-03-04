import SwiftUI
import SwiftUIIntrospection
import XCTest

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
        hostingController.endAppearanceTransition()
    }
}

final class UIKitTests: XCTestCase {
    func testTextField() throws {
        struct TextFieldTestView: View {
            let spy1: (UITextField) -> Void
            let spy2: (UITextField) -> Void
            let spy3: (UITextField) -> Void
            @State private var textFieldValue = ""

            let textField1Placeholder = "Text Field 1"
            let textField2Placeholder = "Text Field 2"
            let textField3Placeholder = "Text Field 3"

            var body: some View {
                VStack {
                    TextField(textField1Placeholder, text: $textFieldValue)
//                    .introspectTextField { textField in
//                        self.spy1(textField)
//                    }
                    .cornerRadius(8)
                    TextField(textField2Placeholder, text: $textFieldValue)
//                    .introspectTextField { textField in
//                        self.spy2(textField)
//                    }
                    .cornerRadius(8)
                    TextField(textField3Placeholder, text: $textFieldValue)
//                    .introspectTextField { textField in
//                        self.spy3(textField)
//                    }
                }
            }
        }

        let expectation1 = XCTestExpectation()
//        expectation1.expectedFulfillmentCount = 2
//        expectation1.assertForOverFulfill = true
        let expectation2 = XCTestExpectation()
//        expectation2.expectedFulfillmentCount = 2
//        expectation2.assertForOverFulfill = true
        let expectation3 = XCTestExpectation()
//        expectation3.expectedFulfillmentCount = 2
//        expectation3.assertForOverFulfill = true

        var textField1: UITextField?
        var textField2: UITextField?
        var textField3: UITextField?

        let view = TextFieldTestView(
            spy1: {
                textField1 = $0
                expectation1.fulfill()
            },
            spy2: {
                textField2 = $0
                expectation2.fulfill()
            },
            spy3: {
                textField3 = $0
                expectation3.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2, expectation3], timeout: TestUtils.Constants.timeout)

        let unwrappedTextField1 = try XCTUnwrap(textField1)
        let unwrappedTextField2 = try XCTUnwrap(textField2)
        let unwrappedTextField3 = try XCTUnwrap(textField3)

        XCTAssertEqual(unwrappedTextField1.placeholder, view.textField1Placeholder)
        XCTAssertEqual(unwrappedTextField2.placeholder, view.textField2Placeholder)
        XCTAssertEqual(unwrappedTextField3.placeholder, view.textField3Placeholder)
    }
}
