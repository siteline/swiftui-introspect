import Foundation

public protocol ViewType {
    var scope: IntrospectionScope { get }
}

public enum IntrospectionScope {
    case receiver
    case ancestor
    case receiverOrAncestor
}
