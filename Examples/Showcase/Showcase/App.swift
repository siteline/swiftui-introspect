import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            AppView().preferredColorScheme(.light)
        }
    }
}

#Preview {
    AppView()
}
