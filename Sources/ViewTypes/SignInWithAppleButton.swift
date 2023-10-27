#if !os(watchOS)
import SwiftUI

/// An abstract representation of the `SignInWithAppleButton` type in SwiftUI.
///
/// ### iOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         SignInWithAppleButton(.signIn) { request in
///             request.requestedScopes = [.fullName, .email]
///         } onCompletion: { result in
///             // do something with result
///         }
///         .introspect(.signInWithAppleButton, on: .iOS(.v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // ASAuthorizationAppleIDButton
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
///         SignInWithAppleButton(.signIn) { request in
///             request.requestedScopes = [.fullName, .email]
///         } onCompletion: { result in
///             // do something with result
///         }
///         .introspect(.signInWithAppleButton, on: .tvOS(.v14, .v15, .v16, .v17)) {
///             print(type(of: $0)) // ASAuthorizationAppleIDButton
///         }
///     }
/// }
/// ```
///
/// ### macOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         SignInWithAppleButton(.signIn) { request in
///             request.requestedScopes = [.fullName, .email]
///         } onCompletion: { result in
///             // do something with result
///         }
///         .introspect(.signInWithAppleButton, on: .macOS(.v11, .v12, .v13, .v14),) {
///             print(type(of: $0)) // ASAuthorizationAppleIDButton
///         }
///     }
/// }
/// ```
///
/// ### visionOS
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         SignInWithAppleButton(.signIn) { request in
///             request.requestedScopes = [.fullName, .email]
///         } onCompletion: { result in
///             // do something with result
///         }
///         .introspect(.signInWithAppleButton, on: .visionOS(.v1)) {
///             print(type(of: $0)) // ASAuthorizationAppleIDButton
///         }
///     }
/// }
/// ```
public struct SignInWithAppleButtonType: IntrospectableViewType {}

#if canImport(AuthenticationServices)
import AuthenticationServices

extension IntrospectableViewType where Self == SignInWithAppleButtonType {
    public static var signInWithAppleButton: Self { .init() }
}

extension iOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
    @available(*, unavailable, message: "SignInWithAppleButton isn't available on iOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
    @available(*, unavailable, message: "SignInWithAppleButton isn't available on tvOS 13")
    public static let v13 = Self.unavailable()
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension macOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
    @available(*, unavailable, message: "SignInWithAppleButton isn't available on macOS 10.15")
    public static let v10_15 = Self.unavailable()
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}

extension visionOSViewVersion<SignInWithAppleButtonType, ASAuthorizationAppleIDButton> {
    public static let v1 = Self(for: .v1)
}
#endif
#endif
