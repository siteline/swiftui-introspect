#if canImport(AuthenticationServices)
import AuthenticationServices
import SwiftUI
import SwiftUIIntrospect
import XCTest

@available(iOS 14, tvOS 14, macOS 11, *)
final class SignInWithAppleButtonTests: XCTestCase {
    typealias PlatformSignInWithAppleButton = ASAuthorizationAppleIDButton

    func testSignInWithAppleButton() throws {
        guard #available(iOS 14, tvOS 14, macOS 11, *) else {
            throw XCTSkip()
        }

        XCTAssertViewIntrospection(of: PlatformSignInWithAppleButton.self) { spies in
            let spy0 = spies[0]
            let spy1 = spies[1]
            let spy2 = spies[2]

            VStack {
                SignInWithAppleButton(.continue, onRequest: { _ in }, onCompletion: { _ in })
                    .introspect(
                        .signInWithAppleButton,
                        on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .macOS(.v11, .v12, .v13, .v14), .visionOS(.v1),
                        customize: spy0
                    )

                SignInWithAppleButton(.signIn, onRequest: { _ in }, onCompletion: { _ in })
                    .introspect(
                        .signInWithAppleButton,
                        on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .macOS(.v11, .v12, .v13, .v14), .visionOS(.v1),
                        customize: spy1
                    )

                SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: { _ in })
                    .introspect(
                        .signInWithAppleButton,
                        on: .iOS(.v14, .v15, .v16, .v17), .tvOS(.v14, .v15, .v16, .v17), .macOS(.v11, .v12, .v13, .v14), .visionOS(.v1),
                        customize: spy2
                    )
            }
        } extraAssertions: {
            XCTAssertNotIdentical($0[safe: 0], $0[safe: 1])
            XCTAssertNotIdentical($0[safe: 0], $0[safe: 2])
            XCTAssertNotIdentical($0[safe: 1], $0[safe: 2])
        }
    }
}
#endif
