#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `TextField` type in SwiftUI, with `.vertical` axis.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     @State var text = "Lorem ipsum"
///
///     var body: some View {
///         TextField("Text Field", text: $text, axis: .vertical)
///             .introspect(.textField(axis: .vertical), on: .iOS(.v16, .v17, .v18)) {
///                 print(type(of: $0)) // UITextView
///             }
///     }
/// }
/// ```
///
/// ### tvOS
///
/// ```swift
/// struct ContentView: View {
///     @State var text = "Lorem ipsum"
///
///     var body: some View {
///         TextField("Text Field", text: $text, axis: .vertical)
///             .introspect(.textField(axis: .vertical), on: .tvOS(.v16, .v17, .v18)) {
///                 print(type(of: $0)) // UITextField
///             }
///     }
/// }
/// ```
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     @State var text = "Lorem ipsum"
///
///     var body: some View {
///         TextField("Text Field", text: $text, axis: .vertical)
///             .introspect(.textField(axis: .vertical), on: .macOS(.v13, .v14, .v15)) {
///                 print(type(of: $0)) // NSTextField
///             }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     @State var text = "Lorem ipsum"
///
///     var body: some View {
///         TextField("Text Field", text: $text, axis: .vertical)
///             .introspect(.textField(axis: .vertical), on: .visionOS(.v1, .v2)) {
///                 print(type(of: $0)) // UITextView
///             }
///     }
/// }
/// ```
public struct TextFieldWithVerticalAxisType: IntrospectableViewType {
    public enum Axis: Sendable {
        case vertical
    }
}

extension IntrospectableViewType where Self == TextFieldWithVerticalAxisType {
    @MainActor public static func textField(axis: Self.Axis) -> Self { .init() }
}

// MARK: SwiftUI.TextField(..., axis: .vertical) - iOS

#if canImport(UIKit)
extension iOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 13")
    @MainActor public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 14")
    @MainActor public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on iOS 15")
    @MainActor public static let v15 = Self.unavailable()

    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension tvOSViewVersion<TextFieldWithVerticalAxisType, UITextField> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 13")
    @MainActor public static let v13 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 14")
    @MainActor public static let v14 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on tvOS 15")
    @MainActor public static let v15 = Self.unavailable()

    @MainActor public static let v16 = Self(for: .v16)
    @MainActor public static let v17 = Self(for: .v17)
    @MainActor public static let v18 = Self(for: .v18)
}

extension visionOSViewVersion<TextFieldWithVerticalAxisType, UITextView> {
    @MainActor public static let v1 = Self(for: .v1)
    @MainActor public static let v2 = Self(for: .v2)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldWithVerticalAxisType, NSTextField> {
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 10.15")
    @MainActor public static let v10_15 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 11")
    @MainActor public static let v11 = Self.unavailable()
    @available(*, unavailable, message: "TextField(..., axis: .vertical) isn't available on macOS 12")
    @MainActor public static let v12 = Self.unavailable()

    @MainActor public static let v13 = Self(for: .v13)
    @MainActor public static let v14 = Self(for: .v14)
    @MainActor public static let v15 = Self(for: .v15)
}
#endif
#endif
