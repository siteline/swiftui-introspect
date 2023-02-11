#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import XCTest
import SwiftUI
@testable import Introspect

@available(macOS 10.15.0, *)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 5
    }
    
    static func present<ViewType: View>(view: ViewType) {
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        window.layoutIfNeeded()
    }
}

@available(macOS 10.15.0, *)
private struct ListTestView: View {
    
    let spy1: () -> Void
    let spy2: () -> Void
    let spyCell1: () -> Void
    let spyCell2: () -> Void

    var body: some View {
        List {
            Text("Item 1")
            Text("Item 2")
                .introspectTableView { tableView in
                    self.spy2()
                }
                .introspectTableViewCell { cell in
                    self.spyCell2()
                }
            
        }
        .introspectTableView { tableView in
            self.spy1()
        }
        .introspectTableViewCell { cell in
            self.spyCell1()
        }
    }
}

@available(macOS 10.15.0, *)
private struct ScrollTestView: View {
    
    let spy1: (NSScrollView) -> Void
    let spy2: (NSScrollView) -> Void
    
    var body: some View {
        HStack {
            ScrollView {
                Text("Item 1")
            }
            .introspectScrollView { scrollView in
                self.spy1(scrollView)
            }

            ScrollView {
                Text("Item 1")
                    .introspectScrollView { scrollView in
                        self.spy2(scrollView)
                    }
            }
        }
    }
}

@available(macOS 10.15.0, *)
private struct NestedScrollTestView: View {

    let spy1: (NSScrollView) -> Void
    let spy2: (NSScrollView) -> Void

    var body: some View {
        HStack {
            ScrollView {
                Text("Item 1")

                ScrollView {
                    Text("Item 1")
                }
                .introspectScrollView { scrollView in
                    self.spy2(scrollView)
                }
            }
            .introspectScrollView { scrollView in
                self.spy1(scrollView)
            }
        }
    }
}

@available(macOS 10.15.0, *)
private struct TextFieldTestView: View {
    let spy: () -> Void
    @State private var textFieldValue = ""
    var body: some View {
        TextField("Text Field", text: $textFieldValue)
        .introspectTextField { textField in
            self.spy()
        }
    }
}

@available(macOS 11.0, *)
private struct TextEditorTestView: View {
    let spy: () -> Void
    @State private var textEditorValue = ""
    var body: some View {
        TextEditor(text: $textEditorValue)
        .introspectTextView { textView in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct SliderTestView: View {
    let spy: () -> Void
    @State private var sliderValue = 0.0
    var body: some View {
        Slider(value: $sliderValue, in: 0...100)
        .introspectSlider { slider in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct StepperTestView: View {
    let spy: () -> Void
    var body: some View {
        Stepper(onIncrement: {}, onDecrement: {}) {
            Text("Stepper")
        }
        .introspectStepper { stepper in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct DatePickerTestView: View {
    let spy: () -> Void
    @State private var datePickerValue = Date()
    var body: some View {
        DatePicker(selection: $datePickerValue) {
            Text("DatePicker")
        }
        .introspectDatePicker { datePicker in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct SegmentedControlTestView: View {
    @State private var pickerValue = 0
    let spy: () -> Void
    var body: some View {
        Picker(selection: $pickerValue, label: Text("Segmented control")) {
            Text("Option 1").tag(0)
            Text("Option 2").tag(1)
            Text("Option 3").tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .introspectSegmentedControl { segmentedControl in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct TabViewTestView: View {
    let spy: () -> Void
    var body: some View {
        TabView {
            Text("Contents")
                .tabItem {
                    Text("Tab 1")
                }
            Text("Contents")
                .tabItem {
                    Text("Tab 2")
                }
        }
        .introspectTabView { tabView in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct ButtonTestView: View {
    let spy: () -> Void
    var body: some View {
        Button("Test", action: {})
        .introspectButton { button in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
private struct ToggleTestView: View {
    let spy: () -> Void
    @State private var toggleValue = false
    var body: some View {
        Toggle("Toggle", isOn: $toggleValue)
        .introspectButton { button in
            self.spy()
        }
    }
}

@available(macOS 11.0, *)
private struct ColorWellTestView: View {
    @State private var color = Color.black
    let spy: () -> Void
    
    var body: some View {
        ColorPicker("Picker", selection: $color)
        .introspectColorWell { colorWell in
            self.spy()
        }
    }
}

@available(macOS 10.15.0, *)
class AppKitTests: XCTestCase {
    
    func testList() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let cellExpectation1 = XCTestExpectation()
        let cellExpectation2 = XCTestExpectation()
        
        let view = ListTestView(
            spy1: { expectation1.fulfill() },
            spy2: { expectation2.fulfill() },
            spyCell1: { cellExpectation1.fulfill() },
            spyCell2: { cellExpectation2.fulfill() }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2, cellExpectation1, cellExpectation2], timeout: TestUtils.Constants.timeout)
    }

    func testScrollView() throws {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: NSScrollView?
        var scrollView2: NSScrollView?

        let view = ScrollTestView(
            spy1: { scrollView in
                scrollView1 = scrollView
                expectation1.fulfill() },
            spy2: { scrollView in
                scrollView2 = scrollView
                expectation2.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollView1 = try XCTUnwrap(scrollView1)
        let unwrappedScrollView2 = try XCTUnwrap(scrollView2)

        XCTAssertNotEqual(unwrappedScrollView1, unwrappedScrollView2)
    }

    func testNestedScrollView() throws {

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: NSScrollView?
        var scrollView2: NSScrollView?

        let view = NestedScrollTestView(
            spy1: { scrollView in
                scrollView1 = scrollView
                expectation1.fulfill()
            },
            spy2: { scrollView in
                scrollView2 = scrollView
                expectation2.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollView1 = try XCTUnwrap(scrollView1)
        let unwrappedScrollView2 = try XCTUnwrap(scrollView2)

        XCTAssertNotEqual(unwrappedScrollView1, unwrappedScrollView2)
    }

    func testTextField() {
        
        let expectation = XCTestExpectation()
        let view = TextFieldTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testTextEditor() {

        if #available(macOS 11.0, *) {
            let expectation = XCTestExpectation()
            let view = TextEditorTestView(spy: {
                expectation.fulfill()
            })
            TestUtils.present(view: view)
            wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        }
    }
    
    func testSlider() {
        
        let expectation = XCTestExpectation()
        let view = SliderTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testStepper() {
        
        let expectation = XCTestExpectation()
        let view = StepperTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testDatePicker() {
        
        let expectation = XCTestExpectation()
        let view = DatePickerTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testSegmentedControl() {
        
        let expectation = XCTestExpectation()
        let view = SegmentedControlTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testTabView() {
        
        let expectation = XCTestExpectation()
        let view = TabViewTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testButton() {
        
        let expectation = XCTestExpectation()
        let view = ButtonTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testToggle() {
        
        let expectation = XCTestExpectation()
        let view = ToggleTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testColorPicker() {

        if #available(macOS 11.0, *) {
            let expectation = XCTestExpectation()
            let view = ColorWellTestView(spy: {
                expectation.fulfill()
            })
            TestUtils.present(view: view)
            wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        }
    }
}
#endif
