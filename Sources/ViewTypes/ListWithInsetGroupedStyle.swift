import SwiftUI

/// An abstract representation of the `List` type in SwiftUI, with `.insetGrouped` style.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         List {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .listStyle(.insetGrouped)
///         .introspect(.list(style: .insetGrouped), on: .iOS(.v14, .v15)) {
///             print(type(of: $0)) // UITableView
///         }
///         .introspect(.list(style: .insetGrouped), on: .iOS(.v16, .v17)) {
///             print(type(of: $0)) // UICollectionView
///         }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// Not available.
///
/// ### macOS
///
/// Not available.
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         List {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .listStyle(.insetGrouped)
///         .introspect(.list(style: .insetGrouped), on: .visionOS(.v1)) {
///             print(type(of: $0)) // UICollectionView
///         }
///     }
/// }
/// ```
public struct ListWithInsetGroupedStyleType: IntrospectableViewType {
    public enum Style {
        case insetGrouped
    }
}

#if !os(tvOS) && !os(macOS)
extension IntrospectableViewType where Self == ListWithInsetGroupedStyleType {
    public static func list(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ListWithInsetGroupedStyleType, UITableView> {
    @available(*, unavailable, message: ".listStyle(.insetGrouped) isn't available on iOS 13")
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<ListWithInsetGroupedStyleType, UICollectionView> {
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension visionOSViewVersion<ListWithInsetGroupedStyleType, UICollectionView> {
    public static let v1 = Self(for: .v1)
}
#endif
#endif
