@_spi(Internals)
public struct IntrospectionSelector<Target: PlatformEntity> {
    @_spi(Internals)
    public static var `default`: Self { .from(Target.self, selector: { $0 }) }

    @_spi(Internals)
    public static func from<Entry: PlatformEntity>(_ entryType: Entry.Type, selector: @escaping (Entry) -> Target?) -> Self {
        .init(
            receiverSelector: { controller, anchorID in
                controller.as(Entry.self)?.receiver(ofType: Entry.self, anchorID: anchorID).flatMap(selector)
            },
            ancestorSelector: { controller in
                controller.as(Entry.self)?.ancestor(ofType: Entry.self).flatMap(selector)
            }
        )
    }

    private var receiverSelector: (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?
    private var ancestorSelector: (IntrospectionPlatformViewController) -> Target?

    private init(
        receiverSelector: @escaping (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?,
        ancestorSelector: @escaping (IntrospectionPlatformViewController) -> Target?
    ) {
        self.receiverSelector = receiverSelector
        self.ancestorSelector = ancestorSelector
    }

    @_spi(Internals)
    public func withReceiverSelector(_ selector: @escaping (PlatformViewController, IntrospectionAnchorID) -> Target?) -> Self {
        var copy = self
        copy.receiverSelector = selector
        return copy
    }

    @_spi(Internals)
    public func withAncestorSelector(_ selector: @escaping (PlatformViewController) -> Target?) -> Self {
        var copy = self
        copy.ancestorSelector = selector
        return copy
    }

    func callAsFunction(
        _ controller: IntrospectionPlatformViewController,
        _ scope: IntrospectionScope,
        _ anchorID: IntrospectionAnchorID
    ) -> Target? {
        if
            scope.contains(.receiver),
            let target = receiverSelector(controller, anchorID)
        {
            return target
        }
        if
            scope.contains(.ancestor),
            let target = ancestorSelector(controller)
        {
            return target
        }
        return nil
    }
}

extension PlatformViewController {
    func `as`<Entity: PlatformEntity>(_ entityType: Entity.Type) -> (any PlatformEntity)? {
        if Entity.Base.self == PlatformView.self {
            #if canImport(UIKit)
            return viewIfLoaded
            #elseif canImport(AppKit)
            return isViewLoaded ? view : nil
            #endif
        } else if Entity.Base.self == PlatformViewController.self {
            return self
        }
        return nil
    }
}
