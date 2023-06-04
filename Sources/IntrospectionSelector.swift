@_spi(Internals)
public struct IntrospectionSelector<Target: PlatformEntity> {
    private var receiverSelector: (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?
    private var ancestorSelector: (IntrospectionPlatformViewController) -> Target?

    @_spi(Internals)
    public static var `default`: Self { .from(Target.self, selector: { $0 }) }

    @_spi(Internals)
    public func withAncestorSelector(
        _ selector: @escaping (PlatformViewController) -> Target?
    ) -> Self {
        var copy = self
        copy.ancestorSelector = selector
        return copy
    }

    @_spi(Internals)
    public static func from<Entry: PlatformEntity>(_ entryType: Entry.Type, selector: @escaping (Entry) -> Target?) -> Self {
        .init(
            receiver: { controller, anchorID in
                controller.as(Entry.self)?.receiver(ofType: Entry.self, anchorID: anchorID).flatMap(selector)
            },
            ancestor: { controller in
                controller.as(Entry.self)?.ancestor(ofType: Entry.self).flatMap(selector)
            }
        )
    }

    init(
        receiver: @escaping (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?,
        ancestor: @escaping (IntrospectionPlatformViewController) -> Target?
    ) {
        self.receiverSelector = receiver
        self.ancestorSelector = ancestor
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
