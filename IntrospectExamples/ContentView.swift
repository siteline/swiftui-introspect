import SwiftUI
import Introspect

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            ListExample()
                .tabItem { Text("List") }
                .tag(0)
                .introspectTabBarController { tabBarController in
                    tabBarController.tabBar.layer.backgroundColor = UIColor.green.cgColor
                }
            ScrollViewExample()
                .tabItem { Text("ScrollView") }
                .tag(1)
            NavigationExample()
                .tabItem { Text("Navigation") }
                .tag(2)
            ViewControllerExample()
                .tabItem { Text("ViewController") }
                .tag(3)
            SimpleElementsExample()
                .tabItem { Text("Simple elements") }
                .tag(4)
        }
    }
}

struct ListExample: View {
    var body: some View {
        
        HStack {
            VStack {
                Text("Default")
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
            }
                
            VStack {
                Text("List.introspectTableView()")
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
                .introspectTableView { tableView in
                    tableView.separatorStyle = .none
                }
            }
            
            VStack {
                Text("child.introspectTableView()")
                List {
                    Text("Item 1")
                    Text("Item 2")
                        .introspectTableView { tableView in
                            tableView.separatorStyle = .none
                        }
                }
            }
        }
        
    }
}

struct NavigationExample: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Customized")
            }
            .navigationBarTitle(Text("Customized"), displayMode: .inline)
            .introspectNavigationController { nvc in
                nvc.navigationBar.backgroundColor = .red
            }
        }
    }
}

struct ViewControllerExample: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Customized")
            }
            .introspectViewController { viewController in
                viewController.navigationItem.title = "Customized"
            }
        }
    }
}

struct ScrollViewExample: View {
    var body: some View {
        HStack {
            ScrollView {
                Text("Default")
            }
            ScrollView {
                Text("ScrollView.introspectScrollView()")
            }
            .introspectScrollView { scrollView in
                scrollView.layer.backgroundColor = UIColor.red.cgColor
            }
            ScrollView {
                Text("child.introspectScrollView()")
                .introspectScrollView { scrollView in
                    scrollView.layer.backgroundColor = UIColor.green.cgColor
                }
            }
        }
    }
}

struct SimpleElementsExample: View {
    
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
                .introspectTextField { textField in
                    textField.layer.backgroundColor = UIColor.green.cgColor
                }
            }
            
            HStack {
                Toggle("Toggle Red", isOn: $toggleValue)
                .introspectSwitch { uiSwitch in
                    uiSwitch.layer.backgroundColor = UIColor.red.cgColor
                }
                
                Toggle("Toggle Green", isOn: $toggleValue)
                .introspectSwitch { uiSwitch in
                    uiSwitch.layer.backgroundColor = UIColor.green.cgColor
                }
            }
            
            HStack {
                Slider(value: $sliderValue, in: 0...100)
                .introspectSlider { slider in
                    slider.layer.backgroundColor = UIColor.red.cgColor
                }
                
                Slider(value: $sliderValue, in: 0...100)
                .introspectSlider { slider in
                    slider.layer.backgroundColor = UIColor.green.cgColor
                }
            }
            
            HStack {
                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Red")
                }
                .introspectStepper { stepper in
                    stepper.layer.backgroundColor = UIColor.red.cgColor
                }
                
                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Green")
                }
                .introspectStepper { stepper in
                    stepper.layer.backgroundColor = UIColor.green.cgColor
                }
            }
            
            HStack {
                DatePicker(selection: $datePickerValue) {
                    Text("DatePicker Red")
                }
                .introspectDatePicker { datePicker in
                    datePicker.layer.backgroundColor = UIColor.red.cgColor
                }
            }
            
            HStack {
                Picker(selection: $segmentedControlValue, label: Text("Segmented control")) {
                    Text("Option 1").tag(0)
                    Text("Option 2").tag(1)
                    Text("Option 3").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .introspectSegmentedControl { segmentedControl in
                    segmentedControl.layer.backgroundColor = UIColor.red.cgColor
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListExample()
            NavigationExample()
        }
    }
}
