import SwiftUI

#if canImport(UIKit)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 3
    }

    static func present<ViewType: View>(view: ViewType) {
        let hostingController = UIHostingController(rootView: view)

        for window in UIApplication.shared.windows {
            if let presentedViewController = window.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: nil)
            }
            window.isHidden = true
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.layer.speed = 10

        hostingController.beginAppearanceTransition(true, animated: false)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        hostingController.endAppearanceTransition()
    }
}
#elseif canImport(AppKit)
enum TestUtils {
    enum Constants {
        static let timeout: TimeInterval = 5
    }

    static func present<ViewType: View>(view: ViewType) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: true
        )

        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        window.layoutIfNeeded()
    }
}
#endif
