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

    var body: some View {
        NavigationView {
            List {
                Picker("Color", selection: $color, content: {
                    Text("Red").tag(Color.red)
                    Text("Green").tag(Color.green)
                    Text("Blue").tag(Color.blue)
                })
                TextField("dq", text: .constant("dqede"))
                    .modifier(Modifier(color: color))
            }
        }
    }
}

struct Modifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .introspectTextField { textField in
                textField.backgroundColor = UIColor(color)
            }
    }
}
