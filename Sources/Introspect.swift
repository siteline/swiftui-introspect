import SwiftUI

/// The scope of introspection i.e. where introspect should look to find
/// the desired target view relative to the applied `.introspect(...)`
/// modifier.
public struct IntrospectionScope: OptionSet {
    /// Look within the `receiver` of the `.introspect(...)` modifier.
    public static let receiver = Self(rawValue: 1 << 0)
    /// Look for an `ancestor` relative to the `.introspect(...)` modifier.
    public static let ancestor = Self(rawValue: 1 << 1)

    @_spi(Private) public let rawValue: UInt

    @_spi(Private) public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension View {
    /// Introspects a SwiftUI view to find its underlying UIKit/AppKit instance.
    ///
    /// - Parameters:
    ///   - viewType: The type of view to be introspected.
    ///   - platforms: A list of `PlatformViewVersions` that specify platform-specific entities associated with the view, with one or more corresponding version numbers.
    ///   - scope: An optional `IntrospectionScope` that specifies the scope of introspection.
    ///   - customize: A closure that hands over the underlying UIKit/AppKit instance ready for customization.
    ///
    /// Here's an example usage:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State var date = Date()
    ///
    ///     var body: some View {
    ///         DatePicker("Pick a date", selection: $date)
    ///             .introspect(.datePicker, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
    ///                 print(type(of: $0)) // UIDatePicker
    ///             }
    ///     }
    /// }
    /// ```
    public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity>(
        _ viewType: SwiftUIViewType,
        on platforms: (PlatformViewVersionGroup<SwiftUIViewType, PlatformSpecificEntity>)...,
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
        platforms: [PlatformViewVersionGroup<SwiftUIViewType, PlatformSpecificEntity>],
        scope: IntrospectionScope?,
        customize: @escaping (PlatformSpecificEntity) -> Void
    ) {
        self.scope = scope ?? viewType.scope
        if let platform = platforms.first(where: \.containsCurrent) {
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
                    // boxes up content without affecting appearance or behavior, for more accurate `.view` introspection
                    Color.white
                        .opacity(0)
                        .accessibility(hidden: true)
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

#if canImport(UIKit)
extension UIPresentationController: PlatformEntity {
    @_spi(Internals)
    public var ancestor: UIPresentationController? { nil }

    @_spi(Internals)
    public var descendants: [UIPresentationController] { [] }

    @_spi(Internals)
    public func isDescendant(of other: UIPresentationController) -> Bool { false }
}
#elseif canImport(AppKit)
extension NSWindow: PlatformEntity {
    @_spi(Internals)
    public var ancestor: NSWindow? { nil }

    @_spi(Internals)
    public var descendants: [NSWindow] { [] }

    @_spi(Internals)
    public func isDescendant(of other: NSWindow) -> Bool { false }
}
#endif
