import SwiftUI
import SwiftUIIntrospection

@main
struct App: SwiftUI.App {


    var body: some Scene {
        WindowGroup {
            Something()
        }
    }
}

struct Something: View {
    @State var color = Color.green
    @State var text = "s"

    var body: some View {
//        NavigationView {
            VStack {
                Picker("Color", selection: $color, content: {
                    Text("Red").tag(Color.red)
                    Text("Green").tag(Color.green)
                    Text("Blue").tag(Color.blue)
                })
                TextField("dq", text: $text)
                    .introspectTextField { textField in
                        textField.backgroundColor = UIColor(color)
                    }
                TextField("dq", text: $text)
                    .introspectTextField { textField in
                        textField.backgroundColor = UIColor(color)
                    }
            }
//        }
    }
}
