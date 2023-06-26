import SwiftUI

/// An abstract representation of a presented view's type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Presentation {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .introspect(.form, on: .iOS(.v13, .v14, .v15)) {
///             print(type(of: $0)) // UITableView
///         }
///         .introspect(.form, on: .iOS(.v16, .v17)) {
///             print(type(of: $0)) // UICollectionView
///         }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Presentation {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .introspect(.form, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // UITableView
///         }
///     }
/// }
/// ```
///
/// ### macOS
///
/// Not available.
///
public struct PresentationType: IntrospectableViewType {}

#if os(iOS) || os(tvOS)
extension IntrospectableViewType where Self == PresentationType {
    public static var presentation: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<PresentationType, UIPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .default.withAncestorSelector(\.presentationController)
    }
}

extension tvOSViewVersion<PresentationType, UIPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .default.withAncestorSelector(\.presentationController)
    }
}

extension UIPresentationController: PlatformEntity {
    @_spi(Internals)
    public var ancestor: UIPresentationController? {
        nil
    }

    @_spi(Internals)
    public var descendants: [UIPresentationController] {
        []
    }

    @_spi(Internals)
    public func isDescendant(of other: UIPresentationController) -> Bool {
        false
    }
}
#endif
#endif
