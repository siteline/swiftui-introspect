postfix operator ~

postfix func ~ <LHS, T>(lhs: LHS) -> T {
    lhs as! T
}

postfix func ~ <LHS, T>(lhs: LHS?) -> T? {
    lhs as? T
}
