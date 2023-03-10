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
//            List {
        HStack {
            Picker("Color", selection: $color) {
                Text("Red").tag(Color.red)
                Text("Green").tag(Color.green)
                Text("Blue").tag(Color.blue)
            }
            Spacer()
            TextField("dq", text: $text)
                .background(Color.green)
//                .introspectTextField { textField in
//                    textField.backgroundColor = UIColor(color)
//                }
                .fixedSize()
        }
                TextField("dq", text: $text)
//                    .background(Color.green)
                    .introspectTextField { textField in
                        textField.backgroundColor = UIColor(color)
                    }
//            }
//        }
    }
}
