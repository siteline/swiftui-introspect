import SwiftUI
import SwiftUIIntrospection

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
//            ListShowcase()
//                .tabItem { Text("List") }
//                .tag(0)
//                .introspectTabBarController { tabBarController in
//                    tabBarController.tabBar.layer.backgroundColor = UIColor.green.cgColor
//                }
//            ScrollViewShowcase()
//                .tabItem { Text("ScrollView") }
//                .tag(1)
//            NavigationShowcase()
//                .tabItem { Text("Navigation") }
//                .tag(2)
//            ViewControllerShowcase()
//                .tabItem { Text("ViewController") }
//                .tag(3)
            SimpleElementsShowcase()
                .tabItem { Text("Simple elements") }
                .tag(4)
        }
    }
}

//struct ListShowcase: View {
//    var body: some View {
//
//        HStack {
//            VStack {
//                Text("Default")
//                List {
//                    Text("Item 1")
//                    Text("Item 2")
//                }
//            }
//
//            VStack {
//                Text("List.introspectTableView()")
//                List {
//                    Text("Item 1")
//                    Text("Item 2")
//                }
//                .introspectTableView { tableView in
//                    #if !os(tvOS)
//                    tableView.separatorStyle = .none
//                    #endif
//                }
//            }
//
//            VStack {
//                Text("child.introspectTableView()")
//                List {
//                    Text("Item 1")
//                    Text("Item 2")
//                        .introspectTableView { tableView in
//                            #if !os(tvOS)
//                            tableView.separatorStyle = .none
//                            #endif
//                        }
//                }
//            }
//        }
//
//    }
//}
//
//struct NavigationShowcase: View {
//    var body: some View {
//        NavigationView {
//            Text("Customized")
//                .modify {
//                    if #available(iOS 15, tvOS 15, *) {
//                        $0.searchable(text: .constant(""))
//                    } else {
//                        $0
//                    }
//                }
//                .modify {
////                    #if os(iOS)
//                    if #available(iOS 15, *) {
//                        $0.introspectSearchController { searchController in
//                            searchController.searchBar.backgroundColor = .purple
//                        }
//                    } else {
//                        $0
//                    }
////                    #else
////                    $0
////                    #endif
//                }
////                #if !os(tvOS)
////                .navigationBarTitle(Text("Customized"), displayMode: .inline)
////                #endif
////                .introspectNavigationController { navigationController in
////                    navigationController.navigationBar.backgroundColor = .red
////                }
//        }
//        .introspectSplitViewController { splitViewController in
//            splitViewController.preferredDisplayMode = .oneOverSecondary
//        }
//    }
//}
//
//struct ViewControllerShowcase: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Customized")
//            }
//            .introspectViewController { viewController in
//                viewController.navigationItem.title = "Customized"
//            }
//        }
//    }
//}
//
//struct ScrollViewShowcase: View {
//    var body: some View {
//        HStack {
//            ScrollView {
//                Text("Default")
//            }
//            ScrollView {
//                Text("ScrollView.introspectScrollView()")
//            }
//            .introspectScrollView { scrollView in
//                scrollView.layer.backgroundColor = UIColor.red.cgColor
//            }
//            ScrollView {
//                Text("child.introspectScrollView()")
//                    .introspectScrollView { scrollView in
//                        scrollView.layer.backgroundColor = UIColor.green.cgColor
//                    }
//            }
//        }
//    }
//}

struct SimpleElementsShowcase: View {

    @State private var textFieldValue = ""
    @State private var toggleValue = false
    @State private var sliderValue = 0.0
    @State private var datePickerValue = Date()
    @State private var segmentedControlValue = 0

    var body: some View {
        VStack {
            HStack {
                TextField("Text Field Red", text: $textFieldValue)
                    .introspectTextField { textField in
                        textField.layer.backgroundColor = UIColor.red.cgColor
                    }

                TextField("Text Field Green", text: $textFieldValue)
                    .cornerRadius(8)
                    .introspectTextField { textField in
                        textField.layer.backgroundColor = UIColor.green.cgColor
                    }
            }

//            HStack {
//                Toggle("Toggle Red", isOn: $toggleValue)
//                    #if !os(tvOS)
//                    .introspectSwitch { uiSwitch in
//                        uiSwitch.layer.backgroundColor = UIColor.red.cgColor
//                    }
//                    #endif
//
//                Toggle("Toggle Green", isOn: $toggleValue)
//                    #if !os(tvOS)
//                    .introspectSwitch { uiSwitch in
//                        uiSwitch.layer.backgroundColor = UIColor.green.cgColor
//                    }
//                    #endif
//            }
//
//            #if !os(tvOS)
//            HStack {
//                Slider(value: $sliderValue, in: 0...100)
//                    .introspectSlider { slider in
//                        slider.layer.backgroundColor = UIColor.red.cgColor
//                    }
//
//                Slider(value: $sliderValue, in: 0...100)
//                    .introspectSlider { slider in
//                        slider.layer.backgroundColor = UIColor.green.cgColor
//                    }
//            }
//
//            HStack {
//                Stepper(onIncrement: {}, onDecrement: {}) {
//                    Text("Stepper Red")
//                }
//                .introspectStepper { stepper in
//                    stepper.layer.backgroundColor = UIColor.red.cgColor
//                }
//
//                Stepper(onIncrement: {}, onDecrement: {}) {
//                    Text("Stepper Green")
//                }
//                .introspectStepper { stepper in
//                    stepper.layer.backgroundColor = UIColor.green.cgColor
//                }
//            }
//
//            HStack {
//                DatePicker(selection: $datePickerValue) {
//                    Text("DatePicker Red")
//                }
//                .introspectDatePicker { datePicker in
//                    datePicker.layer.backgroundColor = UIColor.red.cgColor
//                }
//            }
//            #endif

//            HStack {
//                Picker(selection: $segmentedControlValue, label: Text("Segmented control")) {
//                    Text("Option 1").tag(0)
//                    Text("Option 2").tag(1)
//                    Text("Option 3").tag(2)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .introspectSegmentedControl { segmentedControl in
//                    segmentedControl.layer.backgroundColor = UIColor.red.cgColor
//                }
//            }
        }

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ListShowcase()
//            NavigationShowcase()
//        }
//    }
//}
