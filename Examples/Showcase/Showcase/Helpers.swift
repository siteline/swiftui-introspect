import SwiftUI

extension View {
    @ViewBuilder
    func modifier<TransformedView: View>(
        @ViewBuilder transform: (Self) -> TransformedView
    ) -> TransformedView {
        transform(self)
    }
}
