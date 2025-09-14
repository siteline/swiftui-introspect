#if !os(tvOS)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct TextEditorTests {
	#if canImport(UIKit)
	typealias PlatformTextEditor = UITextView
	#elseif canImport(AppKit)
	typealias PlatformTextEditor = NSTextView
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformTextEditor.self) { spy1, spy2, spy3 in
			VStack {
				TextEditor(text: .constant("Text Field 0"))
					#if os(iOS) || os(visionOS)
					.introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.textEditor, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				TextEditor(text: .constant("Text Field 1"))
					#if os(iOS) || os(visionOS)
					.introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.textEditor, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				TextEditor(text: .constant("Text Field 2"))
					#if os(iOS) || os(visionOS)
					.introspect(.textEditor, on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.textEditor, on: .macOS(.v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#if canImport(UIKit)
		#expect(entity1.text == "Text Field 0")
		#expect(entity2.text == "Text Field 1")
		#expect(entity3.text == "Text Field 2")
		#elseif canImport(AppKit)
		#expect(entity1.string == "Text Field 0")
		#expect(entity2.string == "Text Field 1")
		#expect(entity3.string == "Text Field 2")
		#endif
	}
}
#endif
