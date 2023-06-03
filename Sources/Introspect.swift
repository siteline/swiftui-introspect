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
        if let platform = platforms.first(where: \.isCurrent) {
            let anchorID = IntrospectionAnchorID()
            self.background(
                IntrospectionAnchorView(
                    id: anchorID
                )
                .frame(width: 0, height: 0)
            )
            .overlay(
                IntrospectionView(
                    selector: { entity in
                        (platform.selector ?? .default)(entity, scope ?? viewType.scope, anchorID)
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
    var ancestor: Base? { get }

    @_spi(Internals)
    var descendants: [Base] { get }

    @_spi(Internals)
    func isDescendant(of other: Base) -> Bool

    @_spi(Internals)
    func entityWithTag(_ tag: Int) -> Base?
}

extension PlatformEntity {
    var ancestors: some Sequence<Base> {
        sequence(first: self~, next: { $0.ancestor~ }).dropFirst()
    }

    var allDescendants: [Base] {
        self.descendants.reduce([self~]) { $0 + $1.allDescendants~ }
    }

    func nearestCommonAncestor(with other: Base) -> Base? {
        var nearestAncestor: Base? = self~

        while let currentEntity = nearestAncestor, !other.isDescendant(of: currentEntity~) {
            nearestAncestor = currentEntity.ancestor~
        }

        return nearestAncestor
    }

    func descendantsBetween(_ bottomEntity: Base, and topEntity: Base) -> [Base] {
        var result: [Base] = []
        var entered = false

        for descendant in self.allDescendants {
            if descendant === bottomEntity {
                entered = true
            } else if descendant === topEntity {
                break
            } else if entered {
                result.append(descendant)
            }
        }

        return result
    }

    func receiver<PlatformSpecificEntity: PlatformEntity>(
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

    func ancestor<PlatformSpecificEntity: PlatformEntity>(
        ofType type: PlatformSpecificEntity.Type
    ) -> PlatformSpecificEntity? {
        self.ancestors
            .lazy
            .compactMap { $0 as? PlatformSpecificEntity }
            .first
    }
}

extension PlatformView: PlatformEntity {
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
