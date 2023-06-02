import SwiftUI

public struct IntrospectionScope: OptionSet {
    public static let receiver = Self(rawValue: 1 << 0)
    public static let ancestor = Self(rawValue: 1 << 1)

    @_spi(Private) public let rawValue: UInt

    @_spi(Private) public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
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
            let id = IntrospectionAnchorID()
            self.background(
                    IntrospectionAnchorView(
                        id: id
                    )
                    .frame(width: 0, height: 0)
                )
                .overlay(
                    IntrospectionView(
                        selector: { (view: PlatformView) in
                            let scope = scope ?? viewType.scope
                            if
                                scope.contains(.receiver),
                                let target = view.receiver(ofType: PlatformSpecificView.self, anchorID: id)
                            {
                                return target
                            }
                            if
                                scope.contains(.ancestor),
                                let target = view.ancestor(ofType: PlatformSpecificView.self)
                            {
                                return target
                            }
                            return nil
                        },
                        customize: customize
                    )
                    .frame(width: 0, height: 0)
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
            let id = IntrospectionAnchorID()
            self.background(
                    IntrospectionAnchorView(
                        id: id
                    )
                    .frame(width: 0, height: 0)
                )
                .overlay(
                    IntrospectionView(
                        selector: { (viewController: PlatformViewController) in
                            let scope = scope ?? viewType.scope
                            if
                                scope.contains(.receiver),
                                let target = viewController.receiver(ofType: PlatformSpecificViewController.self, anchorID: id)
                            {
                                return target
                            }
                            if
                                scope.contains(.ancestor),
                                let target = viewController.ancestor(ofType: PlatformSpecificViewController.self)
                            {
                                return target
                            }
                            return nil
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

extension PlatformView {
    fileprivate func receiver<PlatformSpecificView: PlatformView>(
        ofType type: PlatformSpecificView.Type,
        anchorID: IntrospectionAnchorID
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
        self.superviews
            .lazy
//            .filter { !$0.isIntrospectionController }
            .compactMap { $0 as? PlatformSpecificView }
            .first
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
        ofType type: PlatformSpecificViewController.Type,
        anchorID: IntrospectionAnchorID
    ) -> PlatformSpecificViewController? {
        let frontViewController = self
        guard
            let backViewController = Array(frontViewController.parents).last?.viewControllerWithTag(anchorID.hashValue),
            let superview = backViewController.nearestCommonParent(with: frontViewController)
        else {
            return nil
        }

        return superview
            .childrenBetween(backViewController, and: frontViewController)
            .compactMap { $0 as? PlatformSpecificViewController }
            .first
    }

    fileprivate func ancestor<PlatformSpecificViewController: PlatformViewController>(
        ofType type: PlatformSpecificViewController.Type
    ) -> PlatformSpecificViewController? {
        self.parents
            .lazy
            .filter { !$0.isIntrospectionController }
            .compactMap { $0 as? PlatformSpecificViewController }
            .first
    }
}

extension PlatformViewController {
    private var isIntrospectionController: Bool {
        return self is IntrospectionAnchorPlatformViewController
            || self is IntrospectionPlatformViewController
    }

    private var parents: some Sequence<PlatformViewController> {
        sequence(first: self, next: \.parent).dropFirst()
    }

    private func nearestCommonParent(with viewController: PlatformViewController) -> PlatformViewController? {
        var currentVC: PlatformViewController? = viewController
        while currentVC != nil {
            if self.parents.contains(currentVC!) {
                return currentVC
            }
            currentVC = currentVC?.parent
        }
        return nil
    }

    private func viewControllerWithTag(_ tag: Int) -> PlatformViewController? {
        if self.view.tag == tag {
            return self
        }
        for child in children {
            if let childWithTag = child.viewControllerWithTag(tag) {
                return childWithTag
            }
        }
        return nil
    }

    private func childrenBetween(_ bottomViewController: PlatformViewController, and topViewController: PlatformViewController) -> [PlatformViewController] {
        var entered = false
        var result: [PlatformViewController] = []

        for child in self.allChildren {
            if child === bottomViewController {
                entered = true
                continue
            }
            if child === topViewController {
                return result
            }
            if entered {
                result.append(child)
            }
        }

        return result
    }

    private var allChildren: [PlatformViewController] {
        self.children.reduce([self]) { $0 + $1.allChildren }
    }
}
