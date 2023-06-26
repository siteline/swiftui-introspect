import SwiftUI

/// An abstract representation of `.sheet` in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// public struct ContentView: View {
///     @State var isPresented = false
///
///     public var body: some View {
///         Button("Present", action: { isPresented = true })
///             .sheet(isPresented: $isPresented) {
///                 Button("Dismiss", action: { isPresented = false })
///                     .introspect(.sheet, on: .iOS(.v14, .v15, .v16, .v17)) {
///                         print(type(of: $0)) // UISheetPresentationController
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
///         Button("Present", action: { isPresented = true })
///             .sheet(isPresented: $isPresented) {
///                 Button("Dismiss", action: { isPresented = false })
///                     .introspect(.sheet, on: .tvOS(.v14, .v15, .v16, .v17)) {
///                         print(type(of: $0)) // UISheetPresentationController
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
public struct SheetType: IntrospectableViewType {
    public var scope: IntrospectionScope { .ancestor }
}

#if os(iOS) || os(tvOS)
extension IntrospectableViewType where Self == SheetType {
    public static var sheet: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<SheetType, UIPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
    public static let v14 = Self(for: .v14, selector: selector)

    private static var selector: IntrospectionSelector<UIPresentationController> {
        .from(UIViewController.self, selector: \.presentationController)
    }
}

@available(iOS 15, *)
@available(tvOS, unavailable)
extension iOSViewVersion<SheetType, UISheetPresentationController> {
    public static let v15 = Self(for: .v15, selector: selector)
    public static let v16 = Self(for: .v16, selector: selector)
    public static let v17 = Self(for: .v17, selector: selector)

    private static var selector: IntrospectionSelector<UISheetPresentationController> {
        .from(UIViewController.self, selector: \.sheetPresentationController)
    }
}

extension tvOSViewVersion<SheetType, UIPresentationController> {
    public static let v13 = Self(for: .v13, selector: selector)
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
