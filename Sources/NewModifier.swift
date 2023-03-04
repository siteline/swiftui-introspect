import SwiftUI

//extension View {
//    @ViewBuilder
//    public func introspect<SwiftUIView: ViewType, PlatformView>(
//        _ view: SwiftUIView.Member,
//        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
//        customize: @escaping (PlatformView) -> Void
//    ) -> some View {
//        if let introspectingView = platforms.lazy.compactMap(\.introspectingView).first {
//            self.inject(introspectingView(customize))
//        } else {
//            self
//        }
//    }
//}

extension View {
    @ViewBuilder
    public func injectIntrospectionView<V: IntrospectionView>(_ view: V) -> some View {
//        self.tag(123)
//            .accessibility(identifier: view.id.uuidString)
//            .overlay(view.frame(width: 1, height: 1))

        modifier(IntrospectionContainerModifier(view: view))
//        self.overlay(view.frame(width: 1, height: 1))
    }
}

struct IntrospectionContainerModifier<V: IntrospectionView>: ViewModifier {
    let view: V

    func body(content: Content) -> some View {
        IntrospectionContainer(id: view.containerID) {
            content.overlay(view.frame(width: 1, height: 1))
        }
    }
}
