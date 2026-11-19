/// An abstract representation of the `Button` type in SwiftUI.
///
/// ### iOS
///
/// Not available.
///
/// ### tvOS
///
/// Not available.
///
/// ### macOS 10.15 - 15
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         VStack {
///             Button("Plain Button", action: {})
///                 .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
///                     print(type(of: $0)) // NSButton
///                 }
///
///             Button("Bordered Button", action: {})
///                 .buttonStyle(.bordered)
///                 .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
///                     print(type(of: $0)) // NSButton
///                 }
///
///             Button("Borderless Button", action: {})
///                 .buttonStyle(.borderless)
///                 .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
///                     print(type(of: $0)) // NSButton
///                 }
///
///             Button("Link Button", action: {})
///                 .buttonStyle(.link)
///                 .introspect(.button, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15)) {
///                     print(type(of: $0)) // NSButton
///                 }
///         }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// Not available.
public struct ButtonType: IntrospectableViewType {}

#if !os(iOS) && !os(tvOS) && !os(visionOS)
extension IntrospectableViewType where Self == ButtonType {
	public static var button: Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
public import AppKit

extension macOSViewVersion<ButtonType, NSButton> {
	public static let v10_15 = Self(for: .v10_15)
	public static let v11 = Self(for: .v11)
	public static let v12 = Self(for: .v12)
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
}
#endif
#endif
