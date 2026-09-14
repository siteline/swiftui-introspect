/// An abstract representation of the `Toggle` type in SwiftUI, with `.checkbox` style.
///
/// ### iOS
///
/// Not available.
///
/// ### tvOS
///
/// Not available.
///
/// ### macOS 10.15 - 26
///
/// On macOS 27, toggles with checkbox style are not backed by `NSButton`, so introspection is not possible.
///
/// ```swift
/// struct ContentView: View {
///     @State var isOn = false
///
///     var body: some View {
///         Toggle("Checkbox", isOn: $isOn)
///             .toggleStyle(.checkbox)
///             .introspect(.toggle(style: .checkbox), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) {
///                 print(type(of: $0)) // NSButton
///             }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// Not available.
public struct ToggleWithCheckboxStyleType: IntrospectableViewType {
	public enum Style: Sendable {
		case checkbox
	}
}

#if !os(iOS) && !os(tvOS) && !os(visionOS)
extension IntrospectableViewType where Self == ToggleWithCheckboxStyleType {
	public static func toggle(style: Self.Style) -> Self { .init() }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
public import AppKit

extension macOSViewVersion<ToggleWithCheckboxStyleType, NSButton> {
	public static let v10_15 = Self(for: .v10_15)
	public static let v11 = Self(for: .v11)
	public static let v12 = Self(for: .v12)
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v26 = Self(for: .v26)
	@available(*, unavailable, message: "Toggle with checkbox style isn't backed by NSButton on macOS 27")
	public static let v27 = Self.unavailable
}
#endif
#endif
