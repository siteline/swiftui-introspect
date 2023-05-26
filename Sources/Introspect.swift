import SwiftUI

public enum IntrospectionScope {
    case receiver
    case ancestor
    case receiverOrAncestor
}

extension View {
    @ViewBuilder
    public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificView: PlatformView>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformViewVersions<SwiftUIViewType, PlatformSpecificView>)...,
        scope: IntrospectionScope = .receiver,
        customize: @escaping (PlatformSpecificView) -> Void
    ) -> some View {
        if platforms.contains(where: \.isCurrent) {
            self.overlay(
                IntrospectionView(
                    selector: { (view: PlatformView) in
                        switch scope {
                        case .receiver:
                            return view.receiver(ofType: PlatformSpecificView.self)
                        case .ancestor:
                            return view.ancestor(ofType: PlatformSpecificView.self)
                        case .receiverOrAncestor:
                            return view.receiver(ofType: PlatformSpecificView.self)
                                ?? view.ancestor(ofType: PlatformSpecificView.self)
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

    @ViewBuilder
    public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificViewController: PlatformViewController>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformViewVersions<SwiftUIViewType, PlatformSpecificViewController>)...,
        scope: IntrospectionScope = .receiver,
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        if platforms.contains(where: \.isCurrent) {
            self.overlay(
                IntrospectionView(
                    selector: { (viewController: PlatformViewController) in
                        switch scope {
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

extension PlatformView {
    fileprivate func receiver<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type
    ) -> PlatformSpecificView? {
        guard let hostingView else {
            return nil
        }

//        for container in superviews {
            let children = hostingView.allSubviews(ofType: PlatformSpecificView.self)

            for child in children {
                guard
                    let childFrame = child.superview?.convert(child.frame, to: hostingView),
                    let entryFrame = self.superview?.convert(self.frame, to: hostingView)
                else {
                    continue
                }

                if childFrame.contains(entryFrame) {
//                    print(hostingView)
                    return child
                }
            }
//        }

        return nil
    }

    fileprivate func ancestor<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type
    ) -> PlatformSpecificView? {
        self.superviews.lazy.compactMap { $0 as? PlatformSpecificView }.first
    }
}

extension PlatformView {
    private var superviews: some Sequence<PlatformView> {
        sequence(first: self, next: \.superview).dropFirst()
    }

    private var hostingView: PlatformView? {
        self.superviews.first(where: {
            let type = String(reflecting: type(of: $0))
            return type.hasPrefix("SwiftUI.") && type.contains("Hosting")
        })
    }

    private func allSubviews<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type
    ) -> [PlatformSpecificView] {
        var result = self.subviews.compactMap { $0 as? PlatformSpecificView }
        for subview in self.subviews {
            result.append(contentsOf: subview.allSubviews(ofType: type))
        }
        return result
    }
}

extension PlatformViewController {
    fileprivate func receiver<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.hostingView?.allChildren(ofType: PlatformSpecificViewController.self).first
    }

    fileprivate func ancestor<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.parents.lazy.compactMap { $0 as? PlatformSpecificViewController }.first
    }
}

extension PlatformViewController {
    private var parents: some Sequence<PlatformViewController> {
        sequence(first: self, next: \.parent).dropFirst()
    }

    private var hostingView: PlatformViewController? {
        self.parents.first(where: {
            let type = String(reflecting: type(of: $0))
            return type.hasPrefix("SwiftUI.") && type.contains("Hosting")
        })
    }

    private func allChildren<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> [PlatformSpecificViewController] {
        var result = self.children.compactMap { $0 as? PlatformSpecificViewController }
        for subview in self.children {
            result.append(contentsOf: subview.allChildren(ofType: type))
        }
        return result
    }
}
