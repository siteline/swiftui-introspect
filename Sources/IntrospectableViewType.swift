public protocol IntrospectableViewType {
    var scope: IntrospectionScope { get }
}

extension IntrospectableViewType {
    public var scope: IntrospectionScope { .receiver }
}
