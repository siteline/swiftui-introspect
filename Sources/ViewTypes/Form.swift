#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `Form` type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Form {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .introspect(.form, on: .iOS(.v13, .v14, .v15)) {
///             print(type(of: $0)) // UITableView
///         }
///         .introspect(.form, on: .iOS(.v16, .v17, .v18)) {
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
///         Form {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .introspect(.form, on: .tvOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
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
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Form {
///             Text("Item 1")
///             Text("Item 2")
///             Text("Item 3")
///         }
///         .introspect(.form, on: .visionOS(.v1, .v2)) {
///             print(type(of: $0)) // UICollectionView
///         }
///     }
/// }
/// ```
public struct FormType: IntrospectableViewType {}

#if !os(macOS)
extension IntrospectableViewType where Self == FormType {
    @MainActor public static var form: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<FormType, UITableView> {
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
}

extension iOSViewVersion<FormType, UICollectionView> {
    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension tvOSViewVersion<FormType, UITableView> {
    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension visionOSViewVersion<FormType, UICollectionView> {
    @MainActor public static let v1 = Self(for: .v1)
    @MainActor public static let v2 = Self(for: .v2)
}
#endif
#endif
#endif
