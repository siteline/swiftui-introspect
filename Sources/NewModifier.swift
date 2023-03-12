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
        if let scope = scope ?? platforms.lazy.compactMap(\.scope).first {
            SelfSizingIntrospectionContainer(
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
        } else {
            self
        }
    }
}

struct SelfSizingIntrospectionContainer<Observed, Target: PlatformView, Content: View>: View {
    struct SizeKey: PreferenceKey {
            static var defaultValue: CGSize { .zero }

            static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
                value = nextValue()
            }
        }

    @Binding
    var observed: Observed
    let selector: (UIView) -> Target?
    let customize: (Target, Observed) -> Void
    @ViewBuilder
    let content: () -> Content

    @State
    var idealSize: CGSize?

    var body: some View {
        IntrospectionContainer(observed: $observed, selector: selector, customize: customize) {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizeKey.self, value: proxy.size)
                            .onPreferenceChange(SizeKey.self) { idealSize = $0 }
                    }
                )
        }
        .frame(
            width: idealSize?.width,
            height: idealSize?.height
        )
    }
}
