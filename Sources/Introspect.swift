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
    public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformViewVersions<SwiftUIViewType, PlatformSpecificEntity>)...,
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificEntity) -> Void
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
                        selector: { entity in
                            let scope = scope ?? viewType.scope
                            if
                                scope.contains(.receiver),
                                let target = entity.receiver(ofType: PlatformSpecificEntity.self, anchorID: id)
                            {
                                return target
                            }
                            if
                                scope.contains(.ancestor),
                                let target = entity.ancestor(ofType: PlatformSpecificEntity.self)
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

public protocol PlatformEntity: AnyObject {
    associatedtype Base: PlatformEntity

    @_spi(Internals)
    var isIntrospectionEntity: Bool { get }

    @_spi(Internals)
    var ancestor: Base? { get }

    @_spi(Internals)
    var descendants: [Base] { get }

    @_spi(Internals)
    func isDescendant(of other: Base) -> Bool

    @_spi(Internals)
    func entityWithTag(_ tag: Int) -> Base?
}

extension PlatformEntity {
    @_spi(Internals)
    public var ancestors: some Sequence<Base> {
        sequence(first: self~, next: { $0.ancestor~ }).dropFirst()
    }

    @_spi(Internals)
    public var allDescendants: [Base] {
        self.descendants.reduce([self~]) { $0 + $1.allDescendants~ }
    }

    @_spi(Internals)
    public func nearestCommonAncestor(with other: Base) -> Base? {
        var nearestAncestor: Base? = self~

        while let currentEntity = nearestAncestor, !other.isDescendant(of: currentEntity~) {
            nearestAncestor = currentEntity.ancestor~
        }

        return nearestAncestor
    }

    @_spi(Internals)
    public func descendantsBetween(_ bottomEntity: Base, and topEntity: Base) -> [Base] {
        var entered = false
        var result: [Base] = []

        for descendant in self.allDescendants {
            if descendant === bottomEntity {
                entered = true
                continue
            }
            if descendant === topEntity {
                return result
            }
            if entered {
                result.append(descendant)
            }
        }

        return result
    }

    fileprivate func receiver<PlatformSpecificEntity: PlatformEntity>(
        ofType type: PlatformSpecificEntity.Type,
        anchorID: IntrospectionAnchorID
    ) -> PlatformSpecificEntity? {
        let frontEntity = self
        guard
            let backEntity = Array(frontEntity.ancestors).last?.entityWithTag(anchorID.hashValue),
            let commonAncestor = backEntity.nearestCommonAncestor(with: frontEntity~)
        else {
            return nil
        }

        return commonAncestor
            .descendantsBetween(backEntity~, and: frontEntity~)
            .compactMap { $0 as? PlatformSpecificEntity }
            .first
    }

    fileprivate func ancestor<PlatformSpecificEntity: PlatformEntity>(
        ofType type: PlatformSpecificEntity.Type
    ) -> PlatformSpecificEntity? {
        self.ancestors
            .lazy
            .filter { !$0.isIntrospectionEntity }
            .compactMap { $0 as? PlatformSpecificEntity }
            .first
    }
}

extension PlatformView: PlatformEntity {
    @_spi(Internals)
    public var isIntrospectionEntity: Bool {
        #if canImport(UIKit)
        if let next = self.next as? PlatformViewController {
            return next.isIntrospectionEntity
        }
        #elseif canImport(AppKit)
        if let next = self.nextResponder as? PlatformViewController {
            return next.isIntrospectionEntity
        }
        #endif
        return false
    }

    @_spi(Internals)
    public var ancestor: PlatformView? {
        superview
    }

    @_spi(Internals)
    public var descendants: [PlatformView] {
        subviews
    }

    @_spi(Internals)
    public func entityWithTag(_ tag: Int) -> PlatformView? {
        viewWithTag(tag)
    }
}

extension PlatformViewController: PlatformEntity {
    @_spi(Internals)
    public var isIntrospectionEntity: Bool {
        return self is IntrospectionAnchorPlatformViewController
            || self is IntrospectionPlatformViewController
    }

    @_spi(Internals)
    public var ancestor: PlatformViewController? {
        parent
    }

    @_spi(Internals)
    public var descendants: [PlatformViewController] {
        children
    }

    @_spi(Internals)
    public func isDescendant(of other: PlatformViewController) -> Bool {
        self.ancestors.contains(other)
    }

    @_spi(Internals)
    public func entityWithTag(_ tag: Int) -> PlatformViewController? {
        if self.view.tag == tag {
            return self
        }
        for child in children {
            if let childWithTag = child.entityWithTag(tag) {
                return childWithTag
            }
        }
        return nil
    }
}
