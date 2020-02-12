import Foundation
import SwiftUI
import Cocoa

enum TestUtils {
    static func present<ViewType: View>(view: ViewType) {
        
        let application = NSApplication.shared
        application.windows.forEach { window in
            window.contentViewController?.presentedViewControllers?.forEach { viewController in
                viewController.dismiss(nil)
            }
        }
        
        let hostingController = NSHostingController(rootView: view)
        let window = NSWindow(contentViewController: hostingController)
        window.makeKeyAndOrderFront(nil)
    }
}
