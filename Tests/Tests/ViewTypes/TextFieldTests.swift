import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TextFieldTests {
	#if canImport(UIKit)
	typealias PlatformTextField = UITextField
	#elseif canImport(AppKit)
	typealias PlatformTextField = NSTextField
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformTextField.self) { spy1, spy2, spy3 in
			VStack {
				TextField("", text: .constant("Text Field 1"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				TextField("", text: .constant("Text Field 2"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				TextField("", text: .constant("Text Field 3"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.text == "Text Field 1")
		#expect(entity2.text == "Text Field 2")
		#expect(entity3.text == "Text Field 3")
		#elseif canImport(AppKit)
		#expect(entity1.stringValue == "Text Field 1")
		#expect(entity2.stringValue == "Text Field 2")
		#expect(entity3.stringValue == "Text Field 3")
		#endif
	}

	@Test func introspectEmbeddedInList() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformTextField.self) { spy1, spy2, spy3 in
			List {
				TextField("", text: .constant("Text Field 1"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif

				TextField("", text: .constant("Text Field 2"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif

				TextField("", text: .constant("Text Field 3"))
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.text == "Text Field 1")
		#expect(entity2.text == "Text Field 2")
		#expect(entity3.text == "Text Field 3")
		#elseif canImport(AppKit)
		#expect(entity1.stringValue == "Text Field 1")
		#expect(entity2.stringValue == "Text Field 2")
		#expect(entity3.stringValue == "Text Field 3")
		#endif
	}
}
