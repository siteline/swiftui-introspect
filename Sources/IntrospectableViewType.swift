public protocol IntrospectableViewType {
    /// The scope of introspection for this particular view type.
    ///
    /// While the scope can be overridden by the user in their `introspect` call,
    /// most of the time it's preferable to use the view's own.
    ///
    /// Defaults to `.receiver` if left unimplemented, which is a sensible one in
    /// most cases.
    var scope: IntrospectionScope { get }
}

extension IntrospectableViewType {
    public var scope: IntrospectionScope { .receiver }
}
