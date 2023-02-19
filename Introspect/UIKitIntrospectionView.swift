#if canImport(UIKit)
import UIKit

public typealias IntrospectionUIView = UIView

@available(
    *,
    deprecated,
    message: "UIKitIntrospectionView is deprecated and will be removed in 1.0. Please use UIKitIntrospectionViewController instead."
)
public func UIKitIntrospectionView<Target>(
    selector: @escaping (UIView) -> Target?,
    customize: @escaping (Target) -> Void
) -> UIKitIntrospectionViewController<Target> {
    .init(
        selector: selector,
        customize: customize
    )
}
#endif
