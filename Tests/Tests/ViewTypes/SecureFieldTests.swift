import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct SecureFieldTests {
	#if canImport(UIKit)
	typealias PlatformSecureField = UITextField
	#elseif canImport(AppKit)
	typealias PlatformSecureField = NSTextField
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformSecureField.self) { spy1, spy2, spy3 in
			VStack {
				SecureField("", text: .constant("Secure Field 1"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				SecureField("", text: .constant("Secure Field 2"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				SecureField("", text: .constant("Secure Field 3"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.text == "Secure Field 1")
		#expect(entity2.text == "Secure Field 2")
		#expect(entity3.text == "Secure Field 3")
		#elseif canImport(AppKit)
		#expect(entity1.stringValue == "Secure Field 1")
		#expect(entity2.stringValue == "Secure Field 2")
		#expect(entity3.stringValue == "Secure Field 3")
		#endif
	}

	@Test func introspectEmbeddedInList() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformSecureField.self) { spy1, spy2, spy3 in
			List {
				SecureField("", text: .constant("Secure Field 1"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				SecureField("", text: .constant("Secure Field 2"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				SecureField("", text: .constant("Secure Field 3"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.secureField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.secureField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.text == "Secure Field 1")
		#expect(entity2.text == "Secure Field 2")
		#expect(entity3.text == "Secure Field 3")
		#elseif canImport(AppKit)
		#expect(entity1.stringValue == "Secure Field 1")
		#expect(entity2.stringValue == "Secure Field 2")
		#expect(entity3.stringValue == "Secure Field 3")
		#endif
	}
}
