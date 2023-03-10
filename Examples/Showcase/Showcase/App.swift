import SwiftUI
import SwiftUIIntrospection

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
//            TextField("Text", text: .constant("Hello"))
//                                .introspectTextField { textField in
//                                    textField.backgroundColor = .red
//                                }
//                                .brightness(0.1) // <- this causes introspection to fail
//            Form {
//                TextField("Email", text: .constant("hello"))
//                    .introspectTextField {
//                        $0.becomeFirstResponder()
//                    }
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.emailAddress)
//            }

//            VStack {
//                TextField("Name", text: .constant(""))
//                    .introspectTextField { textField in
//                        textField.clearButtonMode = .whileEditing
//                    }
//            }
//            .clipped()
            ExampleView()

//            Something()
        }
    }
}

struct SecureToggle: ViewModifier {

        @Binding public var isSecure: Bool

        public func body(content: Content) -> some View {

            HStack {
                content
                    .introspectTextField { (textfield) in
                        textfield.isSecureTextEntry = isSecure
                    }

                Spacer()

                Button(action: {
                    self.isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash":"eye").frame(width: 20, height: 20)
                }
                .padding()
            }
        }

    }

struct ExampleView: View {
    @State private var textContent: String = ""
    @State private var isSecure: Bool = false

    var body: some View {
        VStack {
            TextField("", text: $textContent)
                .modifier(SecureToggle(isSecure: $isSecure))
                .border(Color.black, width: 1)
        }.padding(20)
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
//                .background(Color.green)
//                .fixedSize()
                .introspectTextField { textField in
                    textField.backgroundColor = UIColor(color)
                }
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
