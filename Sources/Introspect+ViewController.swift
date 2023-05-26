import SwiftUI

extension View {
    @ViewBuilder
    public func introspect<SwiftUIViewType: ViewType, PlatformSpecificViewController: PlatformViewController>(
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
