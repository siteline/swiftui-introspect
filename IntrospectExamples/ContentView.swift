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
    @State private var selection = 0
    var body: some View {
        HStack {
            Image(systemName: "folder")
            .introspectImageView { imageView in
                
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
