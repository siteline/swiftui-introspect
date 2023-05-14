import SwiftUI
import SwiftUIIntrospect
import XCTest

final class TextFieldTests: XCTestCase {
    #if canImport(UIKit)
    typealias PlatformTextField = UITextField
    #elseif canImport(AppKit)
    typealias PlatformTextField = NSTextField
    #endif

    func testTextField() throws {
        struct TextFieldTestView: View {
            let spy1: (PlatformTextField) -> Void
            let spy2: (PlatformTextField) -> Void
            let spy3: (PlatformTextField) -> Void

            var body: some View {
                VStack {
                    TextField("", text: .constant("Text Field 1"))
                        #if os(iOS) || os(tvOS)
                        .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                            self.spy1(textField)
                        }
                        #elseif os(macOS)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13)) { textField in
                            self.spy1(textField)
                        }
                        #endif
                        .cornerRadius(8)

                    TextField("", text: .constant("Text Field 2"))
                        #if os(iOS) || os(tvOS)
                        .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                            self.spy2(textField)
                        }
                        #elseif os(macOS)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13)) { textField in
                            self.spy2(textField)
                        }
                        #endif
                        .cornerRadius(8)

                    TextField("", text: .constant("Text Field 3"))
                        #if os(iOS) || os(tvOS)
                        .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                            self.spy3(textField)
                        }
                        #elseif os(macOS)
                        .introspect(.textField, on: .macOS(.v11, .v12, .v13)) { textField in
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
                    XCTAssert(textField1 === $0)
                }
                textField1 = $0
                expectation1.fulfill()
            },
            spy2: {
                if let textField2 = textField2 {
                    XCTAssert(textField2 === $0)
                }
                textField2 = $0
                expectation2.fulfill()
            },
            spy3: {
                if let textField3 = textField3 {
                    XCTAssert(textField3 === $0)
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

        #if canImport(UIKit)
        XCTAssertEqual(unwrappedTextField1.text, "Text Field 1")
        XCTAssertEqual(unwrappedTextField2.text, "Text Field 2")
        XCTAssertEqual(unwrappedTextField3.text, "Text Field 3")
        #elseif canImport(AppKit)
        XCTAssertEqual(unwrappedTextField1.stringValue, "Text Field 1")
        XCTAssertEqual(unwrappedTextField2.stringValue, "Text Field 2")
        XCTAssertEqual(unwrappedTextField3.stringValue, "Text Field 3")
        #endif
    }
}
