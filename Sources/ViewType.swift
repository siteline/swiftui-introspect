import Foundation

public protocol ViewType {}

public enum IntrospectionScope {
    case receiver
    case ancestor
    case receiverOrAncestor
}
