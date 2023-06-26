import SwiftUI

/// An abstract representation of a presented view's type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// public struct ContentView: View {
///     @State var isPresented = false
///
///     public var body: some View {
///         Button("Root", action: { isPresented = true })
///             .sheet(isPresented: $isPresented) {
///                 Text("Sheet")
///                     .introspect(.presentation, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
///                         print(type(of: $0)) // UIPresentationController
///                     }
///             }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// public struct ContentView: View {
///     @State var isPresented = false
///
///     public var body: some View {
///         Button("Root", action: { isPresented = true })
///             .sheet(isPresented: $isPresented) {
///                 Text("Sheet")
///                     .introspect(.presentation, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
///                         print(type(of: $0)) // UIPresentationController
///                     }
///             }
///     }
/// }
/// ```
///
/// ### macOS
///
/// Not available.
///
public struct PresentationType: IntrospectableViewType {
    public var scope: IntrospectionScope { .ancestor }
}

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
        .from(UIViewController.self, selector: \.presentationController)
    }
}

extension tvOSViewVersion<PresentationType, UIPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .from(UIViewController.self, selector: \.presentationController)
    }
}

extension UIPresentationController: PlatformEntity {
    @_spi(Internals)
    public var ancestor: UIPresentationController? { nil }

    @_spi(Internals)
    public var descendants: [UIPresentationController] { [] }

    @_spi(Internals)
    public func isDescendant(of other: UIPresentationController) -> Bool { false }
}
#endif
#endif
