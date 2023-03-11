import SwiftUI

extension View {
//    @ViewBuilder
//    public func introspect<SwiftUIView: ViewType, PlatformView: UIView, Observed>(
//        _ view: SwiftUIView.Member,
//        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
//        customize: @escaping (PlatformView) -> Void
//    ) -> some View {
//        introspect(view, on: platforms, observing: (), customize: { customize($0.0) })
//    }

    @ViewBuilder
    public func introspect<SwiftUIView: ViewType, PlatformView: SwiftUIIntrospection.PlatformView, Observed>(
        _ view: SwiftUIView.Member,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
        scope: IntrospectionScope? = nil,
        observing: @escaping @autoclosure () -> Observed,
        customize: @escaping (PlatformView, Observed) -> Void
    ) -> some View {
        if let scope = platforms.lazy.compactMap(\.scope).first {
            IntrospectionContainer(
                observed: Binding(get: observing, set: { _ in /* will never execute */ }),
                selector: { container in
                    switch scope {
                    case .receiver:
                        return Introspect.findChild(ofType: PlatformView.self, in: container)
                    case .ancestor:
                        return Introspect.findAncestor(ofType: PlatformView.self, from: container)
                    case .receiverOrAncestor:
                        if let receiver = Introspect.findChild(ofType: PlatformView.self, in: container) {
                            return receiver
                        } else if let ancestor = Introspect.findAncestor(ofType: PlatformView.self, from: container) {
                            return ancestor
                        } else {
                            return nil
                        }
                    }
                },
                customize: customize,
                content: { self }
            )
//            .layoutPriority(-1)
        } else {
            self
        }
    }
}

//extension View {
//    public func injectIntrospectionView<Observed, V: IntrospectionView>(
//        observing observed: @escaping @autoclosure () -> Observed,
//        _ view: V
//    ) -> some View {
//        self.modifier(IntrospectionContainerModifier(observed: observed, view: view))
//    }
//}

//struct IntrospectionContainerModifier<Target: UIView>: ViewModifier {
////    let observed: () -> Observed
////    let view: V
//
////    let id: IntrospectionContainerID
////    @Binding
////    var observed: Observed
//    let selector: (UIView) -> Target?
//    let customize: (Target) -> Void
////    @ViewBuilder
////    let content: () -> Content
//
////    init(observed: @escaping () -> Observed, view: V) {
////        self.observed = observed
////        self.view = view
////    }
//
//    func body(content: Content) -> some View {
//        IntrospectionContainer(selector: selector, customize: customize) {
//            content
//        }
//    }
//}
