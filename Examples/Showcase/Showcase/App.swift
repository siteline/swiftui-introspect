import SwiftUI
import SwiftUIIntrospection

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: AppView())
        window?.makeKeyAndVisible()
        return true
    }
}

struct AppView: View {
    var body: some View {
        NavigationView {
            Form {
                TextField("Text", text: .constant("Hello"))
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { textField, _ in
                        textField.backgroundColor = .red
                    }
                    .brightness(0.1) // <- this causes introspection to fail
                Something()
            }
            .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { view, _ in
                view.backgroundColor = .purple
            }
            .introspect(.list, on: .iOS(.v16), observing: ()) { view, _ in
                view.backgroundColor = .purple
            }
            #if !os(tvOS)
            .navigationBarTitle(Text(""), displayMode: .inline)
            #endif
        }
        .navigationViewStyle(.stack)

        VStack {
            TextField("Name", text: .constant(""))
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { textField, _ in
                    textField.clearButtonMode = .whileEditing
                }
        }
        .clipped()

        ExampleView()

        VStack {
            TextField("textField1Placeholder", text: .constant(""))
            .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { textField, _ in
                textField.backgroundColor = .orange
            }
            .cornerRadius(8)
            TextField("textField2Placeholder", text: .constant(""))
            .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { textField, _ in
                textField.backgroundColor = .brown
            }
            .cornerRadius(8)
            TextField("textField3Placeholder", text: .constant(""))
            .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: ()) { textField, _ in
                textField.backgroundColor = .gray
            }
            .cornerRadius(8)
        }
    }
}

struct SecureToggle: ViewModifier {

        @Binding public var isSecure: Bool

        public func body(content: Content) -> some View {

            HStack {
                content
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), observing: isSecure) { textField, isSecure in
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
    @State var color = UIColor.green
    @State var text = "s"

    var body: some View {
//        NavigationView {
//            List {
        HStack {
            Picker("Color", selection: $color) {
                Text("Red").tag(UIColor.red)
                Text("Green").tag(UIColor.green)
                Text("Blue").tag(UIColor.blue)
            }
            .fixedSize()

            TextField("dynamic", text: .constant(""))
//                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField, color in
                    textField.backgroundColor = color
                }
            TextField("red", text: .constant(""))
//                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField, color in
                    textField.backgroundColor = .red
                }
            TextField("yellow", text: .constant(""))
//                .frame(width: 50)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField, color in
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
