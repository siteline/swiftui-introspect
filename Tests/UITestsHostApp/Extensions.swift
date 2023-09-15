import SwiftUI

extension View {
    func prefersHomeButtonHidden() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return self.persistentSystemOverlays(.hidden).defersSystemGestures(on: .bottom)
        } else {
            return self
        }
    }
}
