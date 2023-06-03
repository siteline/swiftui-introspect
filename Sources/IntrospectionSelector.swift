@_spi(Internals)
public struct IntrospectionSelector<Target: PlatformEntity> {
    private let selector: (IntrospectionPlatformViewController, IntrospectionScope, IntrospectionAnchorID) -> Target?

    static var `default`: Self { .from(Target.self, selector: { $0 }) }

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
        self.selector = selector
    }

    func callAsFunction(
        _ controller: IntrospectionPlatformViewController,
        _ scope: IntrospectionScope,
        _ anchorID: IntrospectionAnchorID
    ) -> Target? {
        selector(controller, scope, anchorID)
    }
}
