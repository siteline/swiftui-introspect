import SwiftUI
import SwiftUIIntrospect

#if os(iOS) || os(tvOS)
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
#elseif os(macOS)
@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
#endif

struct AppView: View {
    var body: some View {
        NavigationView {
            Form {
                TextField("Text", text: .constant("Hello"))
                    #if os(iOS) || os(tvOS)
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                        textField.backgroundColor = .red
                    }
                    #elseif os(macOS)
                    .introspect(.textField, on: .macOS(.v13)) { textField in
                        textField.backgroundColor = .red
                    }
                    #endif
                    .brightness(0.1) // <- this causes introspection to fail
                Something()
            }
            #if os(iOS) || os(tvOS)
            .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16)) { view in
                view.backgroundColor = .purple
            }
            .introspect(.list, on: .iOS(.v16)) { view in
                view.backgroundColor = .purple
            }
            #elseif os(macOS)
            #endif
            #if os(iOS)
            .navigationBarTitle(Text(""), displayMode: .inline)
            #endif
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif

        VStack {
            TextField("Name", text: .constant(""))
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                    textField.clearButtonMode = .whileEditing
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
//                    textField.clearButtonMode = .whileEditing
                }
                #endif
        }
        .clipped()

        ExampleView()

        VStack {
            TextField("textField1Placeholder", text: .constant(""))
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                    textField.backgroundColor = .orange
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = .orange
                }
                #endif
                .cornerRadius(8)
            TextField("textField2Placeholder", text: .constant(""))
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                    textField.backgroundColor = .brown
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = .brown
                }
                #endif
                .cornerRadius(8)
            TextField("textField3Placeholder", text: .constant(""))
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16)) { textField in
                    textField.backgroundColor = .gray
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = .gray
                }
                #endif
                .cornerRadius(8)
        }
    }
}

struct SecureToggle: ViewModifier {

        @Binding public var isSecure: Bool

        public func body(content: Content) -> some View {

            HStack {
                content
                    #if os(iOS) || os(tvOS)
                    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), observing: isSecure) { textField in
                        textField.isSecureTextEntry = isSecure
                    }
                    #elseif os(macOS)
                    .introspect(.textField, on: .macOS(.v13)) { textField in
    //                    textField.clearButtonMode = .whileEditing
                    }
                    #endif

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

#if canImport(UIKit)
typealias PlatformColor = UIColor
#elseif canImport(AppKit)
typealias PlatformColor = NSColor
#endif

struct Something: View {
    @State var color = PlatformColor.green
    @State var text = "s"

    var body: some View {
//        NavigationView {
//            List {
        HStack {
            Picker("Color", selection: $color) {
                Text("Red").tag(PlatformColor.red)
                Text("Green").tag(PlatformColor.green)
                Text("Blue").tag(PlatformColor.blue)
            }
            .fixedSize()

            TextField("dynamic", text: .constant(""))
//                .frame(width: 50)
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField in
                    textField.backgroundColor = color
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = color
                }
                #endif
            TextField("red", text: .constant(""))
//                .frame(width: 50)
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField in
                    textField.backgroundColor = .red
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = .red
                }
                #endif
            TextField("yellow", text: .constant(""))
//                .frame(width: 50)
                #if os(iOS) || os(tvOS)
                .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16), .tvOS(.v13, .v14, .v15, .v16), observing: color) { textField in
                    textField.backgroundColor = .yellow
                }
                #elseif os(macOS)
                .introspect(.textField, on: .macOS(.v13)) { textField in
                    textField.backgroundColor = .yellow
                }
                #endif
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
