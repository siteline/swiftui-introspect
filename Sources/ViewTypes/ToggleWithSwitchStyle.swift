#if !os(watchOS)
/// An abstract representation of the `Toggle` type in SwiftUI, with `.switch` style.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     @State var isOn = false
///
///     var body: some View {
///         Toggle("Switch", isOn: $isOn)
///             .toggleStyle(.switch)
///             .introspect(.toggle(style: .switch), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) {
///                 print(type(of: $0)) // UISwitch
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
/// ```swift
/// struct ContentView: View {
///     @State var isOn = false
///
///     var body: some View {
///         Toggle("Switch", isOn: $isOn)
///             .toggleStyle(.switch)
///             .introspect(.toggle(style: .switch), on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) {
///                 print(type(of: $0)) // NSSwitch
///             }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// Not available.
public struct ToggleWithSwitchStyleType: IntrospectableViewType {
    public enum Style: Sendable {
        case `switch`
    }
}

#if !os(tvOS) && !os(visionOS)
extension IntrospectableViewType where Self == ToggleWithSwitchStyleType {
    public static func toggle(style: Self.Style) -> Self { .init() }
}

#if canImport(UIKit)
public import UIKit

extension iOSViewVersion<ToggleWithSwitchStyleType, UISwitch> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
    public static let v18 = Self(for: .v18)
    public static let v26 = Self(for: .v26)
}
#elseif canImport(AppKit)
public import AppKit

extension macOSViewVersion<ToggleWithSwitchStyleType, NSSwitch> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v26 = Self(for: .v26)
}
#endif
#endif
#endif
