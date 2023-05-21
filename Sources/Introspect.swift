import SwiftUI

extension View {
    public func introspect<SwiftUIView: ViewType, PlatformSpecificView: PlatformView>(
        _ view: SwiftUIView,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformSpecificView>)...,
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificView) -> Void
    ) -> some View {
        introspect(view, on: platforms, scope: scope, observe: (), customize: { view in customize(view) })
    }

    public func introspect<SwiftUIView: ViewType, PlatformSpecificView: PlatformView, Observed>(
        _ view: SwiftUIView,
        on platforms: (PlatformDescriptor<SwiftUIView, PlatformSpecificView>)...,
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed, // TODO: `= { () }` in Swift 5.7
        customize: @escaping (PlatformSpecificView) -> Void
    ) -> some View {
        introspect(view, on: platforms, scope: scope, observe: observe(), customize: customize)
    }

    @ViewBuilder
    private func introspect<SwiftUIView: ViewType, PlatformSpecificView: PlatformView, Observed>(
        _ view: SwiftUIView,
        on platforms: [PlatformDescriptor<SwiftUIView, PlatformSpecificView>],
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed,
        customize: @escaping (PlatformSpecificView) -> Void
    ) -> some View {
        if let defaultScope = platforms.lazy.compactMap(\.scope).first {
            self.overlay(
                IntrospectionView(
                    observed: Binding(get: observe, set: { _ in /* will never execute */ }),
                    selector: { introspectionViewController in
                        let scope = scope ?? defaultScope

                        func receiver() -> PlatformSpecificView? {
                            #if canImport(UIKit)
                            if let introspectionView = introspectionViewController.viewIfLoaded {
                                return introspectionView.findReceiver(ofType: PlatformSpecificView.self)
                            } else {
                                return nil
                            }
                            #elseif canImport(AppKit)
                            guard introspectionViewController.isViewLoaded else {
                                return nil
                            }
                            let introspectionView = introspectionViewController.view
                            return introspectionView.findReceiver(ofType: PlatformSpecificView.self)
                            #endif
                        }

                        func ancestor() -> PlatformSpecificView? {
                            #if canImport(UIKit)
                            if let introspectionView = introspectionViewController.viewIfLoaded {
                                return introspectionView.findAncestor(ofType: PlatformSpecificView.self)
                            } else {
                                return nil
                            }
                            #elseif canImport(AppKit)
                            guard introspectionViewController.isViewLoaded else {
                                return nil
                            }
                            let introspectionView = introspectionViewController.view
                            return introspectionView.findAncestor(ofType: PlatformSpecificView.self)
                            #endif
                        }

                        switch scope {
                        case .receiver:
                            return receiver()
                        case .ancestor:
                            return ancestor()
                        case .receiverOrAncestor:
                            return receiver() ?? ancestor()
                        }
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
    func findReceiver<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type
    ) -> PlatformSpecificView? {
        guard let hostingView = self.hostingView else {
            return nil
        }

//        for container in superviews {
            let children = hostingView.recursivelyFindSubviews(ofType: PlatformSpecificView.self)

            for child in children {
                guard
                    let childFrame = child.superview?.convert(child.frame, to: hostingView),
                    let entryFrame = self.superview?.convert(self.frame, to: hostingView)
                else {
                    continue
                }

                if childFrame.contains(entryFrame) {
                    print(hostingView)
                    return child
                }
            }
//        }

        return nil
    }

    func findAncestor<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type
    ) -> PlatformSpecificView? {
        self.superviews.lazy.compactMap { $0 as? PlatformSpecificView }.first
    }

    var superviews: AnySequence<PlatformView> {
        AnySequence(sequence(first: self, next: \.superview).dropFirst())
    }

    var hostingView: PlatformView? {
        self.superviews.first(where: { NSStringFromClass(type(of: $0)).contains("Hosting") })
    }

    func recursivelyFindSubviews<T: PlatformView>(ofType type: T.Type) -> [T] {
        var result = self.subviews.compactMap { $0 as? T }
        for subview in self.subviews {
            result.append(contentsOf: subview.recursivelyFindSubviews(ofType: type))
        }
        return result
    }
}
