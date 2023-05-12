import SwiftUI

extension View {
    public func introspect<SwiftUIView: ViewType, PlatformView: SwiftUIIntrospect.PlatformView>(
        _ view: SwiftUIView,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformView) -> Void
    ) -> some View {
        introspect(view, on: platforms, scope: scope, observe: (), customize: { view in customize(view) })
    }

    public func introspect<SwiftUIView: ViewType, PlatformView: SwiftUIIntrospect.PlatformView, Observed>(
        _ view: SwiftUIView,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformView>)...,
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed, // TODO: `= { () }` in Swift 5.7
        customize: @escaping (PlatformView) -> Void
    ) -> some View {
        introspect(view, on: platforms, scope: scope, observe: observe(), customize: customize)
    }

    @ViewBuilder
    private func introspect<SwiftUIView: ViewType, PlatformView: SwiftUIIntrospect.PlatformView, Observed>(
        _ view: SwiftUIView,
        on platforms: [PlatformDescriptor<SwiftUIView, PlatformView>],
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed,
        customize: @escaping (PlatformView) -> Void
    ) -> some View {
        if let scope = scope ?? platforms.lazy.compactMap(\.scope).first { // FIXME: not right... separately, figure out whether scope overriding is actually needed here it at all
            self.overlay(
                IntrospectionView(
                    observed: Binding(get: observe, set: { _ in /* will never execute */ }),
                    selector: { introspectionViewController in
                        #if canImport(UIKit)
                        if let introspectionView = introspectionViewController.viewIfLoaded {
                            return introspectionView.findReceiver(ofType: PlatformView.self)
                        } else {
                            return nil
                        }
                        #elseif canImport(AppKit)
                        guard introspectionViewController.isViewLoaded else {
                            return nil
                        }
                        let introspectionView = introspectionViewController.view
                        return introspectionView.findReceiver(ofType: PlatformView.self)
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
    func findReceiver<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type
    ) -> AnyViewType? {
        for superview in self.superviews {
            let children = superview.recursivelyFindSubviews(ofType: AnyViewType.self)

            for child in children {
                guard
                    let childFrame = child.superview?.convert(child.frame, to: superview),
                    let entryFrame = self.superview?.convert(self.frame, to: superview)
                else {
                    continue
                }
                
                if childFrame.contains(entryFrame) {
                    print(superview)
                    return child
                }
            }
        }
        return nil
    }

    var superviews: AnySequence<PlatformView> {
        AnySequence(sequence(first: self, next: \.superview).dropFirst())
    }

    func recursivelyFindSubviews<T: PlatformView>(ofType type: T.Type) -> [T] {
        var result = self.subviews.compactMap { $0 as? T }
        for subview in self.subviews {
            result.append(contentsOf: subview.recursivelyFindSubviews(ofType: type))
        }
        return result
    }
}
