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
    let spy: (UINavigationController) -> Void
    let navigationBarHidden = false
    let navigationBarTitle = "Introspect"
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .navigationBarHidden(navigationBarHidden)
            .introspectNavigationController { navigationController in
                self.spy(navigationController)
            }
        }
        .navigationBarTitle(Text(navigationBarTitle), displayMode: .large)
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct SplitNavigationTestView: View {
    let spy: (UISplitViewController) -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .introspectSplitViewController { navigationController in
            self.spy(navigationController)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct ViewControllerTestView: View {
    let spy: (UIViewController) -> Void
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .introspectViewController { viewController in
            self.spy(viewController)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct NavigationRootTestView: View {
    let spy: (UINavigationController) -> Void
    var accessiblityLabel = "IntrospectNavigationRootTestView"
    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
        }
        .accessibility(identifier: accessiblityLabel)
        .introspectNavigationController { navigationController in
            self.spy(navigationController)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct TabRootTestView: View {
    @State var selection = 1
    let view1Title = "Playing"
    let view2Title = "Settings"
    let spy: (UITabBarController) -> Void
    var body: some View {
        TabView(selection: $selection) {
            Text("View 1")
                .tabItem{
                    Image(systemName: "play.circle.fill")
                    Text("Playing")
                }
                .tag(0)
            Text("View 2")
                .tabItem{
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(1)
        }
        .introspectTabBarController { tabBarController in
            self.spy(tabBarController)
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
    
    let spyVertical: (UIScrollView) -> Void
    let spyHorizontal: (UIScrollView) -> Void
    var showIndicator = false
    var body: some View {
        HStack {
            ScrollView(.vertical, showsIndicators: showIndicator) {
                Text("Item 1")
            }
            .introspectScrollView { scrollView in
                self.spyVertical(scrollView)
            }
            ScrollView(.horizontal, showsIndicators: showIndicator) {
                Text("Item 1")
            }
            .introspectScrollView { scrollView in
                self.spyHorizontal(scrollView)
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
    let spy: (UITextView) -> Void
    @State var textEditorValue = ""
    var body: some View {
        TextEditor(text: $textEditorValue)
        .introspectTextView { textView in
            self.spy(textView)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
private struct ToggleTestView: View {
    let spy: (UISwitch) -> Void
    @State var toggleValue = true
    var title = "Toggle"
    var body: some View {
        Toggle(title, isOn: $toggleValue)
            .toggleStyle(SwitchToggleStyle())
        .introspectSwitch { uiSwitch in
            self.spy(uiSwitch)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
private struct SliderTestView: View {
    let spy: (UISlider) -> Void
    @State var sliderValue = 0.0
    var range = 0.0...100.0
    var body: some View {
        Slider(value: $sliderValue, in: range)
        .introspectSlider { slider in
            self.spy(slider)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
private struct StepperTestView: View {
    let spy: (UIStepper) -> Void
    @State var value = 5.0
    let titleKey = "Stepper"
    let step = 2.0
    let range = 0.0...10.0
    var body: some View {
        Stepper(titleKey, value: $value, in: range, step: step)
        .introspectStepper { stepper in
            self.spy(stepper)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
@available(tvOS, unavailable)
private struct DatePickerTestView: View {
    let spy: (UIDatePicker) -> Void
    @State var datePickerValue = Date()
    var body: some View {
        DatePicker(selection: $datePickerValue) {
            Text("DatePicker")
        }
        .introspectDatePicker { datePicker in
            self.spy(datePicker)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
private struct SegmentedControlTestView: View {
    @State var pickerValue = 1
    let spy: (UISegmentedControl) -> Void
    var body: some View {
        Picker(selection: $pickerValue, label: Text("Segmented control")) {
            Text("Option 1").tag(0)
            Text("Option 2").tag(1)
            Text("Option 3").tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .introspectSegmentedControl { segmentedControl in
            self.spy(segmentedControl)
        }
    }
}

@available(iOS 14.0, tvOS 13.0, macOS 11.0, *)
@available(tvOS, unavailable)
private struct ColorWellTestView: View {
    @State var color = Color.black
    let spy: (UIColorWell) -> Void
    
    var body: some View {
        ColorPicker("Picker", selection: $color)
        .introspectColorWell { colorWell in
            self.spy(colorWell)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, macOS 10.15.0, *)
class UIKitTests: XCTestCase {
    func testNavigation() throws {
        
        let expectation = XCTestExpectation()
        var navigationController: UINavigationController?
        let view = NavigationTestView(spy: {
            navigationController = $0
            expectation.fulfill()
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedNavigationController = try XCTUnwrap(navigationController)
        XCTAssertEqual(unwrappedNavigationController.isNavigationBarHidden, view.navigationBarHidden)
        XCTAssertEqual(unwrappedNavigationController.navigationBar.prefersLargeTitles, true)
    }
    
    func testViewController() throws {
        
        let expectation = XCTestExpectation()
        var viewController: UIViewController?
        let view = ViewControllerTestView(spy: {
            expectation.fulfill()
            viewController = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedViewController = try XCTUnwrap(viewController)
        XCTAssertTrue(unwrappedViewController.view.description.contains(String(describing: ViewControllerTestView.self)))
    }
    
    func testTabViewRoot() throws {
        
        let expectation = XCTestExpectation()
        var tabBarController: UITabBarController?
        let view = TabRootTestView(spy: {
            expectation.fulfill()
            tabBarController = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedTabBarController = try XCTUnwrap(tabBarController)
        XCTAssertEqual(unwrappedTabBarController.selectedIndex, view.selection)
        let view1UnwrappedTitle = try XCTUnwrap(unwrappedTabBarController.tabBar.items?[0].title)
        let view2UnwrappedTitle = try XCTUnwrap(unwrappedTabBarController.tabBar.items?[1].title)
        XCTAssertEqual(view1UnwrappedTitle, view.view1Title)
        XCTAssertEqual(view2UnwrappedTitle, view.view2Title)
        
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

        var scrollViewVertical: UIScrollView?
        var scrollViewHorizontal: UIScrollView?

        let view = ScrollTestView(
            spyVertical: {
                scrollViewVertical = $0
                expectation1.fulfill()
            },
            spyHorizontal: {
                scrollViewHorizontal = $0
                expectation2.fulfill()
            }
        )
        TestUtils.present(view: view)
        wait(for: [expectation1, expectation2], timeout: TestUtils.Constants.timeout)

        let unwrappedScrollViewVertical = try XCTUnwrap(scrollViewVertical)
        let unwrappedScrollViewHorizontal = try XCTUnwrap(scrollViewHorizontal)

        XCTAssertEqual(unwrappedScrollViewVertical.showsVerticalScrollIndicator, view.showIndicator)
        XCTAssertEqual(unwrappedScrollViewHorizontal.showsHorizontalScrollIndicator, view.showIndicator)
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
    
    func testSegmentedControl() throws {
        
        let expectation = XCTestExpectation()
        var segmentedControl: UISegmentedControl?
        let view = SegmentedControlTestView(spy: {
            expectation.fulfill()
            segmentedControl = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedSegmentedControl = try XCTUnwrap(segmentedControl)
        XCTAssertEqual(unwrappedSegmentedControl.numberOfSegments, 3)
        XCTAssertEqual(unwrappedSegmentedControl.selectedSegmentIndex, view.pickerValue)
    }
    
    #if os(iOS)
    func testSplitNavigation() throws {
        
        let expectation = XCTestExpectation()
        var splitController: UISplitViewController?
        let view = SplitNavigationTestView(spy: {
            expectation.fulfill()
            splitController = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedSplitController = try XCTUnwrap(splitController)
        if #available(iOS 14.0, *) {
            XCTAssertEqual(unwrappedSplitController.style, .doubleColumn)
            XCTAssertNotEqual(unwrappedSplitController.style, UISplitViewController().style)
        }
    }
    
    func testRootNavigation() throws {
        
        let expectation = XCTestExpectation()
        var navigationController: UINavigationController?
        let view = NavigationRootTestView(spy: {
            expectation.fulfill()
            navigationController = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        _ = try XCTUnwrap(navigationController)
    }
    
    func testToggle() throws {
        
        let expectation = XCTestExpectation()
        var toggle: UISwitch?
        let view = ToggleTestView(spy: {
            expectation.fulfill()
            toggle = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedToggle = try XCTUnwrap(toggle)
        XCTAssertEqual(unwrappedToggle.isOn, view.toggleValue)
        XCTAssertNotEqual(UISwitch().isOn, view.toggleValue)
        
    }
    
    func testSlider() throws {
        
        let expectation = XCTestExpectation()
        var slider: UISlider?
        let view = SliderTestView(spy: {
            expectation.fulfill()
            slider = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedSlider = try XCTUnwrap(slider)
        XCTAssertEqual(Double(unwrappedSlider.value), view.sliderValue)
        //FIXME: Minimum and maximum values of UISlider are incorrect. Needs further investigation.
    }
    
    func testStepper() throws {
        
        let expectation = XCTestExpectation()
        var stepper: UIStepper?
        let view = StepperTestView(spy: {
            expectation.fulfill()
            stepper = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        _ = try XCTUnwrap(stepper)
        //FIXME: Step, minimum, and maximum values of UIStepper are all incorrect. Needs further investigation
    }
    
    func testDatePicker() throws {
        
        let expectation = XCTestExpectation()
        var datePicker: UIDatePicker?
        let view = DatePickerTestView(spy: {
            expectation.fulfill()
            datePicker = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedDatePicker = try XCTUnwrap(datePicker)
        XCTAssertEqual(unwrappedDatePicker.date, view.datePickerValue)
    }
    
    @available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
    @available(tvOS, unavailable, message: "TextEditor is not available in tvOS.")
    func testTextEditor() throws {

        let expectation = XCTestExpectation()
        var textView: UITextView?
        let view = TextEditorTestView(spy: {
            expectation.fulfill()
            textView = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedTextView = try XCTUnwrap(textView)
        XCTAssertEqual(view.textEditorValue, unwrappedTextView.text)
    }
    
    @available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
    @available(tvOS, unavailable, message: "ColorPicker is not available in tvOS.")
    func testColorPicker() throws {

        let expectation = XCTestExpectation()
        var colorWell: UIColorWell?
        let view = ColorWellTestView(spy: {
            expectation.fulfill()
            colorWell = $0
        })
        TestUtils.present(view: view)
        wait(for: [expectation], timeout: TestUtils.Constants.timeout)
        let unwrappedColorWell = try XCTUnwrap(colorWell)
        XCTAssertEqual(UIColor(view.color), unwrappedColorWell.selectedColor)
    }
    #endif
}
#endif
