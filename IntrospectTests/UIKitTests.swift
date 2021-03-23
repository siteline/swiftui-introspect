#if canImport(UIKit)
import XCTest
import SwiftUI

@testable import Introspect

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct NavigationTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .introspectNavigationController { navigationController in
                self.spy()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct SplitNavigationTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .introspectSplitViewController { navigationController in
            self.spy()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct ViewControllerTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .introspectViewController { viewController in
            self.spy()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct NavigationRootTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .introspectNavigationController { navigationController in
            self.spy()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct TabTestView: View {
    @State private var selection = 0
    let spy: () -> Void
    var body: some View {
        TabView {
            Text("Item 1")
                .tag(0)
                .introspectTabBarController { _ in
                    self.spy()
                }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct TabRootTestView: View {
    @State private var selection = 0
    let spy: () -> Void
    var body: some View {
        TabView {
            Text("Item 1")
                .tag(0)
        }
        .introspectTabBarController { _ in
            self.spy()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct ScrollTestView: View {
    
    let spy1: (UIScrollView) -> Void
    let spy2: (UIScrollView) -> Void
    
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct NestedScrollTestView: View {

    let spy1: (UIScrollView) -> Void
    let spy2: (UIScrollView) -> Void

    var body: some View {
        HStack {
            ScrollView(showsIndicators: true) {
                Text("Item 1")

                ScrollView(showsIndicators: false) {
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct TextFieldTestView: View {
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
            .introspectTextField { textField in
                self.spy1(textField)
            }
            .cornerRadius(8)
            TextField(textField2Placeholder, text: $textFieldValue)
            .introspectTextField { textField in
                self.spy2(textField)
            }
            .cornerRadius(8)
            TextField(textField3Placeholder, text: $textFieldValue)
            .introspectTextField { textField in
                self.spy3(textField)
            }
        }
    }
}

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 13.0, *)
@available(tvOS, unavailable, message: "TextEditor is not available in tvOS.")
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
private struct ToggleTestView: View {
    let spy: () -> Void
    @State private var toggleValue = false
    var body: some View {
        Toggle("Toggle", isOn: $toggleValue)
        .introspectSwitch { uiSwitch in
            self.spy()
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
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

@available(iOS 14.0, tvOS 13.0, macOS 11.0, *)
@available(tvOS, unavailable)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
class UIKitTests: XCTestCase {
    func testNavigation() {
        
        let expectation = XCTestExpectation()
        let view = NavigationTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testViewController() {
        
        let expectation = XCTestExpectation()
        let view = ViewControllerTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testTabView() {
        
        let expectation = XCTestExpectation()
        let view = TabTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testTabViewRoot() {
        
        let expectation = XCTestExpectation()
        let view = TabRootTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
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

        var scrollView1: UIScrollView?
        var scrollView2: UIScrollView?

        let view = ScrollTestView(
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

    func testNestedScrollView() throws {

        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()

        var scrollView1: UIScrollView?
        var scrollView2: UIScrollView?

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

    func testTextField() throws {
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let expectation3 = XCTestExpectation()
        
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
    
    func testSegmentedControl() {
        
        let expectation = XCTestExpectation()
        let view = SegmentedControlTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    #if os(iOS)
    func testSplitNavigation() {
        
        let expectation = XCTestExpectation()
        let view = SplitNavigationTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    func testRootNavigation() {
        
        let expectation = XCTestExpectation()
        let view = NavigationRootTestView(spy: {
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
    
    @available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
    @available(tvOS, unavailable, message: "TextEditor is not available in tvOS.")
    func testTextEditor() {

        let expectation = XCTestExpectation()
        let view = TextEditorTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    
    @available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
    @available(tvOS, unavailable, message: "ColorPicker is not available in tvOS.")
    func testColorPicker() {

        let expectation = XCTestExpectation()
        let view = ColorWellTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
    }
    #endif
}
#endif
