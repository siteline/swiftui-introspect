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
    public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformViewVersions<SwiftUIViewType, PlatformSpecificEntity>)...,
        scope: IntrospectionScope? = nil,
        customize: @escaping (PlatformSpecificEntity) -> Void
    ) -> some View {
        self.modifier(IntrospectModifier(viewType, platforms: platforms, scope: scope, customize: customize))
    }
}

struct IntrospectModifier<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity>: ViewModifier {
    let id = IntrospectionViewID()
    let scope: IntrospectionScope
    let selector: IntrospectionSelector<PlatformSpecificEntity>?
    let customize: (PlatformSpecificEntity) -> Void

    init(
        _ viewType: SwiftUIViewType,
        platforms: [PlatformViewVersions<SwiftUIViewType, PlatformSpecificEntity>],
        scope: IntrospectionScope?,
        customize: @escaping (PlatformSpecificEntity) -> Void
    ) {
        self.scope = scope ?? viewType.scope
        if let platform = platforms.first(where: \.isCurrent) {
            self.selector = platform.selector ?? .default
        } else {
            self.selector = nil
        }
        self.customize = customize
    }

    func body(content: Content) -> some View {
        if let selector {
            content
                .background(
                    Color.white.opacity(0) // boxes up content for more accurate `.view` introspection, without affecting original appearance or behavior
                )
                .background(
                    IntrospectionAnchorView(id: id)
                        .frame(width: 0, height: 0)
                        .accessibility(hidden: true)
                )
                .overlay(
                    IntrospectionView(id: id, selector: { selector($0, scope) }, customize: customize)
                        .frame(width: 0, height: 0)
                        .accessibility(hidden: true)
                )
        } else {
            content
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
}

extension PlatformEntity {
    @_spi(Internals)
    public var ancestors: some Sequence<Base> {
        sequence(first: self~, next: { $0.ancestor~ }).dropFirst()
    }

    @_spi(Internals)
    public var allDescendants: some Sequence<Base> {
        recursiveSequence([self~], children: { $0.descendants~ }).dropFirst()
    }

    func nearestCommonAncestor(with other: Base) -> Base? {
        var nearestAncestor: Base? = self~

        while let currentEntity = nearestAncestor, !other.isDescendant(of: currentEntity~) {
            nearestAncestor = currentEntity.ancestor~
        }

        return nearestAncestor
    }

    func allDescendants(between bottomEntity: Base, and topEntity: Base) -> some Sequence<Base> {
        self.allDescendants
            .lazy
            .drop(while: { $0 !== bottomEntity })
            .prefix(while: { $0 !== topEntity })
    }

    func receiver<PlatformSpecificEntity: PlatformEntity>(
        ofType type: PlatformSpecificEntity.Type
    ) -> PlatformSpecificEntity? {
        let frontEntity = self
        guard
            let backEntity = frontEntity.introspectionAnchorEntity,
            let commonAncestor = backEntity.nearestCommonAncestor(with: frontEntity~)
        else {
            return nil
        }

        return commonAncestor
            .allDescendants(between: backEntity~, and: frontEntity~)
            .filter { !$0.isIntrospectionPlatformEntity }
            .compactMap { $0 as? PlatformSpecificEntity }
            .first
    }

    func ancestor<PlatformSpecificEntity: PlatformEntity>(
        ofType type: PlatformSpecificEntity.Type
    ) -> PlatformSpecificEntity? {
        self.ancestors
            .lazy
            .filter { !$0.isIntrospectionPlatformEntity }
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
}
