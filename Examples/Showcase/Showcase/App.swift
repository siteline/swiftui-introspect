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
