import SwiftUI

/// An abstract representation of a generic view type in SwiftUI.
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         NavigationView {
///             Text("Root")
///                 #if os(iOS) || os(tvOS)
///                 .introspect(.view, on: .iOS(.v13, .v14, .v15, .v16, .v17), .tvOS(.v13, .v14, .v15, .v16, .v17)) {
///                     print(type(of: $0)) // UIViewController
///                 }
///                 #endif
///         }
///         .navigationViewStyle(.stack)
///     }
/// }
/// ```
public struct ViewType: IntrospectableViewType {
    public var scope: IntrospectionScope { [.receiver, .ancestor] }
}

extension IntrospectableViewType where Self == ViewType {
    public static var view: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<ViewType, UIViewController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<ViewType, UIViewController> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}
#endif
