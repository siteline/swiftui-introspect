import SwiftUI
import SwiftUIIntrospect

struct AppView: View {
    var body: some View {
        ContentView()
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(
                .window,
                on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
            ) { window in
                window.backgroundColor = .brown
            }
            #elseif os(macOS)
            .introspect(.window, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { window in
                window.backgroundColor = .lightGray
            }
            #endif
    }
}

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
            PresentationShowcase()
                .tabItem { Text("Presentation") }
                .tag(3)
            #endif
            ControlsShowcase()
                .tabItem { Text("Controls") }
                .tag(4)
            UIViewRepresentableShowcase()
                .tabItem { Text("UIViewRepresentables") }
                .tag(5)
        }
        #if os(iOS) || os(tvOS)
        .introspect(.tabView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { tabBarController in
            tabBarController.tabBar.layer.backgroundColor = UIColor.green.cgColor
        }
        #elseif os(macOS)
        .introspect(.tabView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14)) { splitView in
            splitView.subviews.first?.layer?.backgroundColor = NSColor.green.cgColor
        }
        #endif
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
