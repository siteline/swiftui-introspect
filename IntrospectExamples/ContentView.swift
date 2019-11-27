import SwiftUI
import Introspect

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            ListExample()
                .tabItem { Text("List") }
                .tag(0)
            NavigationExample()
                .tabItem { Text("Navigation") }
                .tag(1)
            SimpleElementsExample()
                .tabItem { Text("Simple elements") }
                .tag(2)
        }
    }
}

struct ListExample: View {
    var body: some View {
        
        HStack {
            VStack {
                Text("Before")
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
            }
                
            VStack {
                Text("After")
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

struct SimpleElementsExample: View {
    @State private var textFieldValue = ""
    @State private var toggleValue = false
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
