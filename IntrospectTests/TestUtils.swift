import Foundation
import SwiftUI

#if os(iOS)
import UIKit

enum TestUtils {
    static func present<ViewType: View>(view: ViewType) {
        
        let hostingController = UIHostingController(rootView: view)
        
        let application = UIApplication.shared
        application.windows.forEach { window in
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
        hostingController.endAppearanceTransition()
    }
}

#elseif os(macOS)
import AppKit

enum TestUtils {
    static func present<ViewType: View>(view: ViewType) {
        let hostingController = NSHostingController(rootView: view)
        let _ = NSWindow(contentViewController: hostingController)
    }
}

#endif

