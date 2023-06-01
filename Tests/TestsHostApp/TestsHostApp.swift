import SwiftUI

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
        VStack(spacing: 20) {
            Text("Host App for Tests").bold()
            Text("This is just an app target to run tests against, needed for iOS 13 compatibility.")
            Text("If iOS 13 support is dropped in the future, this target can and should be removed and tests should be ran using SPM instead.")
        }
        .multilineTextAlignment(.center)
        .padding()
        #if os(macOS)
        .fixedSize()
        #endif
    }
}
