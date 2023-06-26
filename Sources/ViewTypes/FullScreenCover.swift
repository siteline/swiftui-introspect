import SwiftUI

/// An abstract representation of `.fullScreenCover` in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// public struct ContentView: View {
///     @State var isPresented = false
///
///     public var body: some View {
///         Button("Root", action: { isPresented = true })
///             .fullScreenCover(isPresented: $isPresented) {
///                 Text("Content")
///                     .introspect(.fullScreenCover, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
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
///             .fullScreenCover(isPresented: $isPresented) {
///                 Text("Content")
///                     .introspect(.fullScreenCover, on: .tvOS(.v13, .v14, .v15, .v16, .v17)) {
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
public struct FullScreenCoverType: IntrospectableViewType {
    public var scope: IntrospectionScope { .ancestor }
}

#if os(iOS) || os(tvOS)
extension IntrospectableViewType where Self == FullScreenCoverType {
    public static var fullScreenCover: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<FullScreenCoverType, UIPresentationController> {
    @available(*, unavailable, message: ".fullScreenCover isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .from(UIViewController.self, selector: \.presentationController)
    }
}

extension tvOSViewVersion<FullScreenCoverType, UIPresentationController> {
    @available(*, unavailable, message: ".fullScreenCover isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .from(UIViewController.self, selector: \.presentationController)
    }
}
#endif
#endif
