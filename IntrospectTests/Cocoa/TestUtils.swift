import Foundation
import SwiftUI
import Cocoa

enum TestUtils {
    static func present<ViewType: View>(view: ViewType) {
        
        let hostingController = NSHostingController(rootView: view)

        let window = NSWindow(frame: NSScreen.main?.bounds)
        window.layer.speed = 10

        hostingController.beginAppearanceTransition(true, animated: false)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        hostingController.endAppearanceTransition()
    }
}
