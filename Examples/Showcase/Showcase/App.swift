import SwiftUI
import SwiftUIIntrospection

@main
struct App: SwiftUI.App {
    @State var some = 3

    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
//                    Picker("sqwsq", selection: $some, content: {
//                        Text("1").tag(1)
//                        Text("2").tag(2)
//                        Text("3").tag(3)
//                    })
                    TextField("", text: .constant("dqede"))
                        .introspectTextField { textField in
                            textField.backgroundColor = .red
                        }
                }
            }
        }
    }
}
