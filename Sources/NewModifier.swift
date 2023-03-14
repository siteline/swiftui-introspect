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
                            let rootSuperview = introspectionView.rootSuperview
                        {
                            return rootSuperview.findChild(
                                ofType: PlatformView.self,
                                usingFrameFrom: introspectionView
                            )
                        } else {
                            return nil
                        }
//                        if
//                            let rootSuperview = introspectionView.rootSuperview
//                        {
//                            return rootSuperview.findChild(
//                                ofType: PlatformView.self,
//                                usingFrameFrom: introspectionView
//                            )
//                        } else {
//                            return nil
//                        }
                        #elseif canImport(AppKit)
                        guard introspectionViewController.isViewLoaded else {
                            return nil
                        }
                        let introspectionView = introspectionViewController.view
                        if
                            let rootSuperview = introspectionView.rootSuperview
                        {
                            return rootSuperview.findChild(
                                ofType: PlatformView.self,
                                usingFrameFrom: introspectionView
                            )
                        } else {
                            return nil
                        }
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
                .frame(width: 1, height: 1) // TODO: maybe 0-sized? check when impl is stable
            )
        } else {
            self
        }
    }
}

extension PlatformView {
    var rootSuperview: PlatformView? {
        superview?.rootSuperview ?? superview
    }
}
