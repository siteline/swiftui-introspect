import SwiftUI

extension View {
    @ViewBuilder
    func modify<TransformedView: View>(
        @ViewBuilder transform: (Self) -> TransformedView
    ) -> TransformedView {
        transform(self)
    }
}
