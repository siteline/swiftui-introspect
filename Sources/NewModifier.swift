import SwiftUI

extension View {
    @ViewBuilder
    public func introspect<SwiftUIView: ViewType, PlatformView>(
        _ view: SwiftUIView.Member,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
        customize: @escaping (PlatformView) -> Void
    ) -> some View {
//        if let introspectingView = platforms.lazy.compactMap(\.introspectingView).first {
//            self.inject(introspectingView(customize))
//        } else {
//            self
//        }
        self
    }
}
