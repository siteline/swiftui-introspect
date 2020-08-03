#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import XCTest
import SwiftUI
@testable import Introspect

@available(macOS 10.15, *)
enum TestUtils {
    static func present<ViewType: View>(view: ViewType) {
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
    }
}

@available(macOS 10.15, *)
private struct ListTestView: View {
    
    let spy1: () -> Void
    let spy2: () -> Void
    
    var body: some View {
        List {
            Text("Item 1")
            Text("Item 2")
                .introspectTableView { tableView in
                    self.spy2()
                }
        }
        .introspectTableView { tableView in
            self.spy1()
        }
    }
}

@available(macOS 10.15, *)
private struct ScrollTestView: View {
    
    let spy1: () -> Void
    let spy2: () -> Void
    
    var body: some View {
        HStack {
            ScrollView {
                Text("Item 1")
            }
            .introspectScrollView { scrollView in
                self.spy1()
            }
            ScrollView {
                Text("Item 1")
                .introspectScrollView { scrollView in
                    self.spy2()
                }
            }
        }
    }
}

@available(macOS 10.15, *)
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

@available(macOS 10.15, *)
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

@available(macOS 10.15, *)
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

@available(macOS 10.15, *)
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

@available(macOS 10.15, *)
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

@available(macOS 10.15, *)
class AppKitTests: XCTestCase {
    
    func testList() {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let view = ListTestView(
            spy1: { expectation1.fulfill() },
            spy2: { expectation2.fulfill() }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
    
    func testScrollView() {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let view = ScrollTestView(
            spy1: { expectation1.fulfill() },
            spy2: { expectation2.fulfill() }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: 1)
    }
    
    func testTextField() {
        
        let expectation = XCTestExpectation()
        let view = TextFieldTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testSlider() {
        
        let expectation = XCTestExpectation()
        let view = SliderTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testStepper() {
        
        let expectation = XCTestExpectation()
        let view = StepperTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testDatePicker() {
        
        let expectation = XCTestExpectation()
        let view = DatePickerTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testSegmentedControl() {
        
        let expectation = XCTestExpectation()
        let view = SegmentedControlTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
}
#endif
