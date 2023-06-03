@_spi(Internals)
public struct IntrospectionSelector<Target: PlatformEntity> {
    private let selector: (any PlatformEntity, IntrospectionScope, IntrospectionAnchorID) -> Target?

    static var `default`: Self { .from(Target.self, selector: { $0 }) }

    @_spi(Internals)
    public static func from<Entry: PlatformEntity>(_ entryType: Entry.Type, selector: @escaping (Entry) -> Target?) -> Self {
        .init { entity, scope, anchorID in
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

    init(_ selector: @escaping (any PlatformEntity, IntrospectionScope, IntrospectionAnchorID) -> Target?) {
        self.selector = selector
    }

    func callAsFunction(
        _ entity: any PlatformEntity,
        _ scope: IntrospectionScope,
        _ anchorID: IntrospectionAnchorID
    ) -> Target? {
        selector(entity, scope, anchorID)
    }
}
