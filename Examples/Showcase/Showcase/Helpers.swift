import SwiftUI

extension View {
    func `do`<TransformedView: View>(
        @ViewBuilder transform: (Self) -> TransformedView
    ) -> TransformedView {
        transform(self)
    }
}
