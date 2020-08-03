#if canImport(UIKit)
import XCTest
import SwiftUI

@testable import Introspect

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
enum TestUtils {
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
private struct ViewControllerTestView: View {
    let spy: () -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .introspectViewController { viewController in
                self.spy()
            }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
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

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
class UIKitTests: XCTestCase {
    func testNavigation() {
        
        let expectation = XCTestExpectation()
        let view = NavigationTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testViewController() {
        
        let expectation = XCTestExpectation()
        let view = ViewControllerTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testTabView() {
        
        let expectation = XCTestExpectation()
        let view = TabTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testTabViewRoot() {
        
        let expectation = XCTestExpectation()
        let view = TabRootTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
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
    
    func testSegmentedControl() {
        
        let expectation = XCTestExpectation()
        let view = SegmentedControlTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    #if os(iOS)
    func testRootNavigation() {
        
        let expectation = XCTestExpectation()
        let view = NavigationRootTestView(spy: {
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: 1)
    }
    
    func testToggle() {
        
        let expectation = XCTestExpectation()
        let view = ToggleTestView(spy: {
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
    #endif
}
#endif
