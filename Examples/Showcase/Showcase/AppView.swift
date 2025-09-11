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

struct UIViewRepresentableShowcase: View {
    var body: some View {
        VStack(spacing: 10) {
            Text(".introspect(.view, ...)")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.system(.subheadline, design: .monospaced))
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .cyan
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.cyan.cgColor
                }
                #endif

            Button("A button", action: {})
                .padding(5)
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .yellow
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.yellow.cgColor
                }
                #endif

            Image(systemName: "scribble")
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .blue
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.blue.cgColor
                }
                #endif
        }
        .padding()
        #if os(iOS) || os(tvOS) || os(visionOS)
        .introspect(
            .view,
            on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
        ) { view in
            view.backgroundColor = .red
        }
        #elseif os(macOS)
        .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
            view.layer?.backgroundColor = NSColor.red.cgColor
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
