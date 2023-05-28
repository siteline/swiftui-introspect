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
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificView) -> Void
    ) -> some View {
        if platforms.contains(where: \.isCurrent) {
            let id = UUID() // FIXME: this is probably preventing state updates... either extract into a ViewModifier or try caching the view once it's found
            self.background(
                    IntrospectionAnchorView(
                        id: id
                    )
                    .frame(width: 1, height: 1) // TODO: maybe 0-sized? check when impl is stable
                )
                .overlay(
                    IntrospectionView(
                        selector: { (view: PlatformView) in
                            switch scope ?? viewType.scope {
                            case .receiver:
                                return view.receiver(ofType: PlatformSpecificView.self, anchorID: id)
                            case .ancestor:
                                return view.ancestor(ofType: PlatformSpecificView.self)
                            case .receiverOrAncestor:
                                return view.receiver(ofType: PlatformSpecificView.self, anchorID: id)
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
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificViewController) -> Void
    ) -> some View {
        if platforms.contains(where: \.isCurrent) {
            self.overlay(
                IntrospectionView(
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

extension PlatformView {
    fileprivate func receiver<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type,
        anchorID: IntrospectionAnchorView.ID
    ) -> PlatformSpecificView? {
        let frontView = self
        guard
            let backView = Array(frontView.superviews).last?.viewWithTag(anchorID.hashValue),
            let superview = backView.nearestCommonSuperviewWith(frontView)
        else {
            return nil
        }

        return superview
            .subviewsBetween(backView, and: frontView)
            .compactMap { $0 as? PlatformSpecificView }
            .first
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

    private func nearestCommonSuperviewWith(_ other: PlatformView) -> PlatformView? {
        var nearestAncestor: PlatformView? = self

        while let currentView = nearestAncestor, !other.isDescendant(of: currentView) {
            nearestAncestor = currentView.superview
        }

        return nearestAncestor
    }

    private func subviewsBetween(_ bottomView: PlatformView, and topView: PlatformView) -> [PlatformView] {
        var entered = false
        var result: [PlatformView] = []

        for subview in self.allSubviews {
            if subview === bottomView {
                entered = true
                continue
            }
            if subview === topView {
                return result
            }
            if entered {
                result.append(subview)
            }
        }

        return result
    }

    private var allSubviews: [PlatformView] {
        self.subviews.reduce([self]) { $0 + $1.allSubviews }
    }
}

extension PlatformViewController {
    fileprivate func receiver<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.hostingView?
            .allChildren(ofType: PlatformSpecificViewController.self)
            .filter { !($0 is IntrospectionPlatformViewController) }
            .first
    }

    fileprivate func ancestor<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.parents
            .lazy
            .filter { !($0 is IntrospectionPlatformViewController) }
            .compactMap { $0 as? PlatformSpecificViewController }
            .first
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
