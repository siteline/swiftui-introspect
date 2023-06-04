@_spi(Internals)
public struct IntrospectionSelector<Target: PlatformEntity> {
    private var receiverSelector: (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?
    private var ancestorSelector: (IntrospectionPlatformViewController, IntrospectionAnchorID) -> Target?

    @_spi(Internals)
    public static var `default`: Self { .from(Target.self, selector: { $0 }) }

    @_spi(Internals)
    public func overrideAncestorSelector(
        _ selector: @escaping (PlatformViewController, IntrospectionAnchorID) -> Target?
    ) -> Self {
        var copy = self
        copy.ancestorSelector = selector
        return copy
    }

    @_spi(Internals)
    public static func from<Entry: PlatformEntity>(_ entryType: Entry.Type, selector: @escaping (Entry) -> Target?) -> Self {
        .init { controller, scope, anchorID in
            guard let entity = { () -> (any PlatformEntity)? in
                if Entry.Base.self == PlatformView.self {
                    #if canImport(UIKit)
                    if let introspectionView = controller.viewIfLoaded {
                        return introspectionView
                    }
                    #elseif canImport(AppKit)
                    if controller.isViewLoaded {
                        return controller.view
                    }
                    #endif
                } else if Entry.Base.self == PlatformViewController.self {
                    return controller
                }
                return nil
            }() else {
                return nil
            }
            if
                scope.contains(.receiver),
                let entry = entity.receiver(ofType: Entry.self, anchorID: anchorID),
                let target = selector(entry)
            {
                return target
            }
            if
                scope.contains(.ancestor),
                let entry = entity.ancestor(ofType: Entry.self),
                let target = selector(entry)
            {
                return target
            }
            return nil
        }
    }

    init(_ selector: @escaping (IntrospectionPlatformViewController, IntrospectionScope, IntrospectionAnchorID) -> Target?) {
        self.receiverSelector = { selector($0, .receiver, $1) }
        self.ancestorSelector = { selector($0, .ancestor, $1) }
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
            let target = ancestorSelector(controller, anchorID)
        {
            return target
        }
        return nil
    }
}
