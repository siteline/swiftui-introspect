import Foundation

public protocol ViewType {
    typealias Member = StaticMember<Self>
}

// TODO: we can drop this when we drop Swift 5.4, and use protocol extensions instead.
// https://github.com/apple/swift-evolution/blob/main/proposals/0299-extend-generic-static-member-lookup.md
public struct StaticMember<Base> {
    let base: Base
}
