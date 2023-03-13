import SwiftUI
import SwiftUIIntrospection

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Form {
                    TextField("Text", text: .constant("Hello"))
                        .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                            textField.backgroundColor = .red
                        }
                        .brightness(0.1) // <- this causes introspection to fail
                    Something()
                }
                .introspect(.list, on: .iOS(.v13, .v14, .v15), observing: ()) { view, _ in
                    view.backgroundColor = .purple
                }
                .introspect(.list, on: .iOS(.v16), observing: ()) { view, _ in
                    view.backgroundColor = .purple
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)

            VStack {
                TextField("Name", text: .constant(""))
                    .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                        textField.clearButtonMode = .whileEditing
                    }
            }
            .clipped()

            ExampleView()

            VStack {
                TextField("textField1Placeholder", text: .constant(""))
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                    textField.backgroundColor = .orange
                }
                .cornerRadius(8)
                TextField("textField2Placeholder", text: .constant(""))
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                    textField.backgroundColor = .brown
                }
                .cornerRadius(8)
                TextField("textField3Placeholder", text: .constant(""))
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), .tvOS(.v14, .v15, .v16), observing: ()) { textField, _ in
                    textField.backgroundColor = .gray
                }
                .cornerRadius(8)
            }

        }
    }
}

struct SecureToggle: ViewModifier {

        @Binding public var isSecure: Bool

        public func body(content: Content) -> some View {

            HStack {
                content
                    .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: isSecure) { textField, isSecure in
                        textField.isSecureTextEntry = isSecure
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
            TextField("dynamic", text: .constant(""))
                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: color) { textField, color in
                    textField.backgroundColor = UIColor(color)
                }
            TextField("red", text: .constant(""))
                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: color) { textField, color in
                    textField.backgroundColor = .red
                }
            TextField("yellow", text: .constant(""))
                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: color) { textField, color in
                    textField.backgroundColor = .yellow
                }
            }
//                TextField("dq", text: $text)
//                    .background(Color.green)
//                .introspect(.textField, on: .iOS(.v14, .v15, .v16), observing: color) { textField, color in
//                    textField.backgroundColor = UIColor(color)
//                }
//                .introspect(.textField, on: .iOS14, .iOS15, .iOS16, observing: color) {
//                    textField.backgroundColor = UIColor(color)
//                }

//            }
//        }
    }
}

extension UIView {
    func recursivelyFindSuperview(where condition: (UIView) -> Bool) -> UIView? {
        if let view = self.superview {
            if condition(view) {
                return view
            } else {
                return view.recursivelyFindSuperview(where: condition)
            }
        } else {
            return nil
        }
    }

    func recursivelyFindSubviews(where condition: (UIView) -> Bool) -> [UIView] {
        var result = self.subviews.filter(condition)
        for sub in self.subviews {
            result.append(contentsOf: sub.recursivelyFindSubviews(where: condition))
        }
        return result
    }
}
