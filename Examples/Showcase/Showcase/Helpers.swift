import SwiftUI

extension View {
    func modify<TransformedView: View>(
        @ViewBuilder transform: (Self) -> TransformedView
    ) -> TransformedView {
        transform(self)
    }
}
