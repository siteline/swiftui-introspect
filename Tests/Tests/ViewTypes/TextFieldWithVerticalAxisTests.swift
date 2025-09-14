import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TextFieldWithVerticalAxisTests {
	#if canImport(UIKit) && (os(iOS) || os(visionOS))
	typealias PlatformTextField = UITextView
	#elseif canImport(UIKit) && os(tvOS)
	typealias PlatformTextField = UITextField
	#elseif canImport(AppKit)
	typealias PlatformTextField = NSTextField
	#endif

	@available(iOS 16, tvOS 16, macOS 13, *)
	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformTextField.self) { spy1, spy2, spy3 in
			VStack {
				TextField("", text: .constant("Text Field 1"), axis: .vertical)
					#if os(iOS) || os(visionOS)
					.introspect(.textField(axis: .vertical), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(tvOS)
					.introspect(.textField(axis: .vertical), on: .tvOS(.v16, .v17, .v18, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.textField(axis: .vertical), on: .macOS(.v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				TextField("", text: .constant("Text Field 2"), axis: .vertical)
					#if os(iOS) || os(visionOS)
					.introspect(.textField(axis: .vertical), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(tvOS)
					.introspect(.textField(axis: .vertical), on: .tvOS(.v16, .v17, .v18, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.textField(axis: .vertical), on: .macOS(.v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				TextField("", text: .constant("Text Field 3"), axis: .vertical)
					#if os(iOS) || os(visionOS)
					.introspect(.textField(axis: .vertical), on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(tvOS)
					.introspect(.textField(axis: .vertical), on: .tvOS(.v16, .v17, .v18, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.textField(axis: .vertical), on: .macOS(.v13, .v14, .v15, .v26), customize: spy3)
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
