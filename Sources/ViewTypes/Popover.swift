import SwiftUI

/// An abstract representation of `.popover` in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     @State var isPresented = false
///
///     var body: some View {
///         Button("Present", action: { isPresented = true })
///             .popover(isPresented: $isPresented) {
///                 Button("Dismiss", action: { isPresented = false })
///                     .introspect(.popover, on: .iOS(.v13, .v14, .v15, .v16, .v17)) {
///                         print(type(of: $0)) // UIPopoverPresentationController
///                     }
///             }
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
///     @State var isPresented = false
///
///     var body: some View {
///         Button("Present", action: { isPresented = true })
///             .popover(isPresented: $isPresented) {
///                 Button("Dismiss", action: { isPresented = false })
///                     .introspect(.popover, on: .visionOS(.v1)) {
///                         print(type(of: $0)) // UIPopoverPresentationController
///                     }
///             }
///     }
/// }
/// ```
public struct PopoverType: IntrospectableViewType {
    public var scope: IntrospectionScope { .ancestor }
}

#if !os(tvOS) && !os(macOS)
extension IntrospectableViewType where Self == PopoverType {
    public static var popover: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<PopoverType, UIPopoverPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UIPopoverPresentationController> {
        .from(UIViewController.self, selector: \.popoverPresentationController)
    }
}

extension visionOSViewVersion<PopoverType, UIPopoverPresentationController> {
    public static let v1 = Self(for: .v1, selector: selector)

    private static var selector: IntrospectionSelector<UIPopoverPresentationController> {
        .from(UIViewController.self, selector: \.popoverPresentationController)
    }
}
#endif
#endif
