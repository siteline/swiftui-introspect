import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @State var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            ListShowcase()
                .tabItem { Text("List") }
                .tag(0)
            ScrollViewShowcase()
                .tabItem { Text("ScrollView") }
                .tag(1)
            #if !os(macOS)
            NavigationShowcase()
                .tabItem { Text("Navigation") }
                .tag(2)
            ViewControllerShowcase()
                .tabItem { Text("ViewController") }
                .tag(3)
            #endif
            SimpleElementsShowcase()
                .tabItem { Text("Simple elements") }
                .tag(4)
        }
        #if os(iOS) || os(tvOS)
        .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { tabBarController in
            tabBarController.tabBar.layer.backgroundColor = UIColor.green.cgColor
        }
        #elseif os(macOS)
        .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13)) { splitView in
            splitView.subviews.first?.layer?.backgroundColor = NSColor.green.cgColor
        }
        #endif
        .preferredColorScheme(.light)
    }
}

struct ListShowcase: View {
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Default")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
            }

            VStack {
                Text(".introspect(.list, ...)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
                #if os(iOS) || os(tvOS)
                .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16)) { tableView in
                    tableView.backgroundView = UIView()
                    tableView.backgroundColor = .cyan
                }
                .introspect(.list, on: .iOS(.v16)) { collectionView in
                    collectionView.backgroundView = UIView()
                    collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
                }
                #elseif os(macOS)
                .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13)) { tableView in
                    tableView.backgroundColor = .cyan
                }
                #endif
            }

            VStack {
                Text(".introspect(.list, ..., scope: .ancestor)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                        #if os(iOS) || os(tvOS)
                        .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16), scope: .ancestor) { tableView in
                            tableView.backgroundView = UIView()
                            tableView.backgroundColor = .cyan
                        }
                        .introspect(.list, on: .iOS(.v16), scope: .ancestor) { collectionView in
                            collectionView.backgroundView = UIView()
                            collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
                        }
                        #elseif os(macOS)
                        .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13), scope: .ancestor) { tableView in
                            tableView.backgroundColor = .cyan
                        }
                        #endif
                }
            }
        }

    }
}

struct ScrollViewShowcase: View {
    var body: some View {
        VStack(spacing: 40) {
            ScrollView {
                Text("Default")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
            }

            ScrollView {
                Text(".introspect(.scrollView, ...)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
            }
            #if os(iOS) || os(tvOS)
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { scrollView in
                scrollView.layer.backgroundColor = UIColor.cyan.cgColor
            }
            #elseif os(macOS)
            .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13)) { scrollView in
                scrollView.drawsBackground = true
                scrollView.backgroundColor = .cyan
            }
            #endif

            ScrollView {
                Text(".introspect(.scrollView, ..., scope: .ancestor)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                    #if os(iOS) || os(tvOS)
                    .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), scope: .ancestor) { scrollView in
                        scrollView.layer.backgroundColor = UIColor.cyan.cgColor
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13), scope: .ancestor) { scrollView in
                        scrollView.drawsBackground = true
                        scrollView.backgroundColor = .cyan
                    }
                    #endif
            }
        }
    }
}

struct NavigationShowcase: View {
    var body: some View {
        NavigationView {
            Text("Content")
                .modifier {
                    if #available(iOS 15, tvOS 15, macOS 12, *) {
                        $0.searchable(text: .constant(""))
                    } else {
                        $0
                    }
                }
                #if os(iOS)
                .navigationBarTitle(Text("Customized"), displayMode: .inline)
                #elseif os(macOS)
                .navigationTitle(Text("Navigation"))
                #endif
        }
        #if os(iOS) || os(tvOS)
        .introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { navigationController in
            navigationController.navigationBar.backgroundColor = .cyan
        }
        .introspect(.navigationView(style: .columns), on: .iOS(.v13, .v14, .v15, .v16)) { splitViewController in
            splitViewController.preferredDisplayMode = .oneOverSecondary
        }
        .introspect(.navigationView(style: .columns), on: .tvOS(.v13, .v14, .v15, .v16)) { navigationController in
            navigationController.navigationBar.backgroundColor = .cyan
        }
        .introspect(.searchField, on: .iOS(.v15, .v16), .tvOS(.v15, .v16)) { searchField in
            searchField.backgroundColor = .red
            #if os(iOS)
            searchField.searchTextField.backgroundColor = .purple
            #endif
        }
        #endif
    }
}

struct ViewControllerShowcase: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Customized")
            }
            #if os(iOS) || os(tvOS)
            .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { viewController in
                viewController.view.backgroundColor = .cyan
            }
            #endif
        }
    }
}

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
//                    .introspectTextField { textField in
//                        textField.layer.backgroundColor = UIColor.red.cgColor
//                    }
//                    .background(Color.red)

                TextField("Text Field Green", text: $textFieldValue)
                    .cornerRadius(8)
//                    .introspectTextField(observe: ) { textField in
//                        textField.layer.backgroundColor = UIColor.green.cgColor
//                    }
//                    .background(Color.green)
            }

            HStack {
                Toggle("Toggle Red", isOn: $toggleValue)
                    #if !os(tvOS)
//                    .introspectSwitch { uiSwitch in
//                        uiSwitch.layer.backgroundColor = UIColor.red.cgColor
//                    }
                    #endif

                Toggle("Toggle Green", isOn: $toggleValue)
                    #if !os(tvOS)
//                    .introspectSwitch { uiSwitch in
//                        uiSwitch.layer.backgroundColor = UIColor.green.cgColor
//                    }
                    #endif
            }

            #if !os(tvOS)
            HStack {
                Slider(value: $sliderValue, in: 0...100)
//                    .introspectSlider { slider in
//                        slider.layer.backgroundColor = UIColor.red.cgColor
//                    }

                Slider(value: $sliderValue, in: 0...100)
//                    .introspectSlider { slider in
//                        slider.layer.backgroundColor = UIColor.green.cgColor
//                    }
            }

            HStack {
                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Red")
                }
//                .introspectStepper { stepper in
//                    stepper.layer.backgroundColor = UIColor.red.cgColor
//                }

                Stepper(onIncrement: {}, onDecrement: {}) {
                    Text("Stepper Green")
                }
//                .introspectStepper { stepper in
//                    stepper.layer.backgroundColor = UIColor.green.cgColor
//                }
            }

            HStack {
                DatePicker(selection: $datePickerValue) {
                    Text("DatePicker Red")
                }
//                .introspectDatePicker { datePicker in
//                    datePicker.layer.backgroundColor = UIColor.red.cgColor
//                }
            }
            #endif

            HStack {
                Picker(selection: $segmentedControlValue, label: Text("Segmented control")) {
                    Text("Option 1").tag(0)
                    Text("Option 2").tag(1)
                    Text("Option 3").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
//                .introspectSegmentedControl { segmentedControl in
//                    segmentedControl.layer.backgroundColor = UIColor.red.cgColor
//                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selection: 1)
    }
}
