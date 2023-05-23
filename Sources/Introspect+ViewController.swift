import SwiftUI

extension View {
    #if swift(>=5.7)
    public func introspect<SwiftUIViewType: ViewType, PlatformSpecificViewController: PlatformViewController, Observed>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformVersionsDescriptor<SwiftUIViewType, PlatformSpecificViewController>)...,
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed = { () },
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        introspect(viewType, on: platforms, scope: scope, observe: observe(), customize: customize)
    }
    #else
    public func introspect<SwiftUIViewType: ViewType, PlatformSpecificViewController: PlatformViewController>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformVersionsDescriptor<SwiftUIViewType, PlatformSpecificViewController>)...,
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        introspect(viewType, on: platforms, scope: scope, observe: (), customize: { view in customize(view) })
    }

    public func introspect<SwiftUIViewType: ViewType, PlatformSpecificViewController: PlatformViewController, Observed>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformVersionsDescriptor<SwiftUIViewType, PlatformSpecificViewController>)...,
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed,
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        introspect(viewType, on: platforms, scope: scope, observe: observe(), customize: customize)
    }
    #endif

    @ViewBuilder
    private func introspect<SwiftUIViewType: ViewType, PlatformSpecificViewController: PlatformViewController, Observed>(
        _ viewType: SwiftUIViewType,
        on platforms: [PlatformVersionsDescriptor<SwiftUIViewType, PlatformSpecificViewController>],
        scope: IntrospectionScope? = nil,
        observe: @escaping @autoclosure () -> Observed,
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        if platforms.contains(where: \.isCurrent) {
            self.overlay(
                IntrospectionView(
                    observe: observe(),
                    selector: { (viewController: PlatformViewController) in
                        switch scope ?? viewType.scope {
                        case .receiver:
                            return viewController.receiver(ofType: PlatformSpecificViewController.self)
                        case .ancestor:
                            return viewController.ancestor(ofType: PlatformSpecificViewController.self)
                        case .receiverOrAncestor:
                            return viewController.receiver(ofType: PlatformSpecificViewController.self)
                                ?? viewController.ancestor(ofType: PlatformSpecificViewController.self)
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

extension PlatformViewController {
    fileprivate func receiver<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        guard let hostingView = self.hostingView else {
            return nil
        }

//        for container in superviews {
            let children = hostingView.allSubviews(ofType: PlatformSpecificViewController.self)

            for child in children {
//                guard
//                    let childFrame = child.superview?.convert(child.frame, to: hostingView),
//                    let entryFrame = self.superview?.convert(self.frame, to: hostingView)
//                else {
//                    continue
//                }
//
//                if childFrame.contains(entryFrame) {
//                    print(hostingView)
                    return child
//                }
            }
//        }

        return nil
    }

    fileprivate func ancestor<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.superviews.lazy.compactMap { $0 as? PlatformSpecificViewController }.first
    }
}

extension PlatformViewController {
    #if swift(>=5.7)
    private var superviews: some Sequence<PlatformViewController> {
        sequence(first: self, next: \.parent).dropFirst()
    }
    #else
    private var superviews: AnySequence<PlatformViewController> {
        AnySequence(sequence(first: self, next: \.parent).dropFirst())
    }
    #endif

    private var hostingView: PlatformViewController? {
        self.superviews.first(where: {
            let type = String(reflecting: type(of: $0))
            return type.hasPrefix("SwiftUI.") && type.contains("Hosting")
        })
    }

    private func allSubviews<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> [PlatformSpecificViewController] {
        var result = self.children.compactMap { $0 as? PlatformSpecificViewController }
        for subview in self.children {
            result.append(contentsOf: subview.allSubviews(ofType: type))
        }
        return result
    }
}
