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
            self.overlay(
                IntrospectionView(
                    observed: Binding(get: observing, set: { _ in /* will never execute */ }),
                    selector: { introspectionViewController in
                        #if canImport(UIKit)
                        if
                            let introspectionView = introspectionViewController.viewIfLoaded,
                            let window = introspectionView.window
                        {
                            return window.findChild(
                                ofType: PlatformView.self,
                                usingFrameFrom: introspectionView
                            )
                        } else {
                            return nil
                        }
                        #elseif canImport(AppKit)
                        // FIXME: NSWindow is not a responder
//                        let introspectionView = introspectionViewController.view
//                        if
//                            let window = introspectionView.window
//                        {
//                            return window.findChild(
//                                ofType: PlatformView.self,
//                                usingFrameFrom: introspectionView
//                            )
//                        } else {
//                            return nil
//                        }
                        #endif
//                        return targetView
//                        switch scope {
//                        case .receiver:
//                            return Introspect.findChild(ofType: PlatformView.self, in: container)
//                        case .ancestor:
//                            return Introspect.findAncestor(ofType: PlatformView.self, from: container)
//                        case .receiverOrAncestor:
//                            if let receiver = Introspect.findChild(ofType: PlatformView.self, in: container) {
//                                return receiver
//                            } else if let ancestor = Introspect.findAncestor(ofType: PlatformView.self, from: container) {
//                                return ancestor
//                            } else {
//                                return nil
//                            }
//                        }
                    },
                    customize: customize
                )
                .frame(width: 0, height: 0)
            )
        } else {
            self
        }
    }
}
