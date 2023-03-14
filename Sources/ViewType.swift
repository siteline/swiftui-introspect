import Foundation

public protocol ViewType {
    static var scope: IntrospectionScope { get }
}

public enum IntrospectionScope {
    case receiver
    case ancestor
    case receiverOrAncestor
}
