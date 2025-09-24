#if !os(tvOS) && !os(visionOS) && !targetEnvironment(macCatalyst)
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct StepperTests {
	#if canImport(UIKit)
	typealias PlatformStepper = UIStepper
	#elseif canImport(AppKit)
	typealias PlatformStepper = NSStepper
	#endif

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformStepper.self) { spy1, spy2, spy3 in
			VStack {
				Stepper("", value: .constant(0), in: 0...10)
					#if os(iOS)
					.introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy1)
					#elseif os(macOS)
					.introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy1)
					#endif
					.cornerRadius(8)

				Stepper("", value: .constant(0), in: 0...10)
					#if os(iOS)
					.introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy2)
					#elseif os(macOS)
					.introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy2)
					#endif
					.cornerRadius(8)

				Stepper("", value: .constant(0), in: 0...10)
					#if os(iOS)
					.introspect(.stepper, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), customize: spy3)
					#elseif os(macOS)
					.introspect(.stepper, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), customize: spy3)
					#endif
			}
		}
		#expect(Set([entity1, entity2, entity3].map(ObjectIdentifier.init)).count == 3)
	}
}
#endif
