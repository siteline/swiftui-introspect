import SwiftUI
import SwiftUIIntrospect
import XCTest

final class IntrospectTests: XCTestCase {}

extension IntrospectTests {
    func testFindReceiver() {
        final class TargetView: PlatformView {}

        let grandparent = PlatformView(frame: .init(x: 0, y: 0, width: 300, height: 300))

        let parent = PlatformView(frame: .init(x: 100, y: 100, width: 100, height: 100)); grandparent.addSubview(parent)

        let a = TargetView(frame: .init(x: 0, y: 0, width: 50, height: 50)); parent.addSubview(a)
        let b = TargetView(frame: .init(x: 50, y: 0, width: 50, height: 50)); parent.addSubview(b)
        let c = TargetView(frame: .init(x: 0, y: 50, width: 50, height: 50)); parent.addSubview(c)
        let d = TargetView(frame: .init(x: 50, y: 50, width: 50, height: 50)); parent.addSubview(d)

        let ai = PlatformView(frame: .init(x: 25, y: 25, width: 0, height: 0)); parent.addSubview(ai)
        let bi = PlatformView(frame: .init(x: 75, y: 25, width: 0, height: 0)); parent.addSubview(bi)
        let ci = PlatformView(frame: .init(x: 25, y: 75, width: 0, height: 0)); parent.addSubview(ci)
        let di = PlatformView(frame: .init(x: 75, y: 75, width: 0, height: 0)); parent.addSubview(di)

        XCTAssert(a === ai.findReceiver(ofType: TargetView.self))
        XCTAssert(b === bi.findReceiver(ofType: TargetView.self))
        XCTAssert(c === ci.findReceiver(ofType: TargetView.self))
        XCTAssert(d === di.findReceiver(ofType: TargetView.self))
    }
}

// MARK: SwiftUI.TextField

extension IntrospectTests {
    #if canImport(UIKit)
    public typealias PlatformTextField = UITextField
    #elseif canImport(AppKit)
    public typealias PlatformTextField = NSTextField
    #endif

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
                    TextField(textField1Placeholder, text: $textFieldValue)
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

                    TextField(textField2Placeholder, text: $textFieldValue)
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

                    TextField(textField3Placeholder, text: $textFieldValue)
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
        XCTAssertEqual(unwrappedTextField1.placeholder, view.textField1Placeholder)
        XCTAssertEqual(unwrappedTextField2.placeholder, view.textField2Placeholder)
        XCTAssertEqual(unwrappedTextField3.placeholder, view.textField3Placeholder)
        #elseif canImport(AppKit)
        XCTAssertEqual(unwrappedTextField1.placeholderString, view.textField1Placeholder)
        XCTAssertEqual(unwrappedTextField2.placeholderString, view.textField2Placeholder)
        XCTAssertEqual(unwrappedTextField3.placeholderString, view.textField3Placeholder)
        #endif
    }
}