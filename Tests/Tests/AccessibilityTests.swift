#if os(iOS) && !targetEnvironment(macCatalyst)
import Combine
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import Testing

/// Accessibility identifiers inside an introspected scroll view stay in the accessibility tree after navigating away
/// and back (#376).
@MainActor
struct AccessibilityTests {
	enum Introspection: String, CaseIterable, CustomTestStringConvertible {
		case none
		case introspection

		var testDescription: String { rawValue }
	}

	@Test(arguments: Introspection.allCases)
	func `identifiers survive navigation`(introspection: Introspection) async throws {
		let automation = try AccessibilityAutomation()
		let wasEnabled = automation.isEnabled
		automation.isEnabled = true
		defer { automation.isEnabled = wasEnabled }

		let model = NavigationModel()
		TestUtils.present(view: RootView(model: model, introspection: introspection))

		let initial = try await identifiers(containing: "Bar")
		#expect(initial.contains("Bar"), "\(initial)")
		#expect(model.isCustomized == (introspection != .none))

		model.isPushed = true
		_ = try await identifiers(containing: "Detail")
		model.isPushed = false

		let afterPop = try await identifiers(containing: "Bar", excluding: "Detail")
		#expect(afterPop == initial, "before: \(initial), after: \(afterPop)")
	}

	/// The identifiers in the window's accessibility tree once it contains the given one and not the excluded one, or
	/// after two seconds.
	private func identifiers(containing identifier: String, excluding excluded: String? = nil) async throws -> [String] {
		let window = try #require(
			UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first?.windows.first,
		)
		let start = Date()
		var identifiers: [String] = []
		repeat {
			try await Task.sleep(nanoseconds: 100_000_000)
			identifiers = accessibilityIdentifiers(in: window)
			if identifiers.contains(identifier), excluded.map({ !identifiers.contains($0) }) ?? true {
				break
			}
		} while Date().timeIntervalSince(start) < 2
		return identifiers
	}

	private func accessibilityIdentifiers(in element: NSObject) -> [String] {
		var identifiers: [String] = []
		// SwiftUI's accessibility nodes implement the identifier without declaring `UIAccessibilityIdentification`.
		if
			element.responds(to: #selector(getter: UIAccessibilityIdentification.accessibilityIdentifier)),
			let identifier = element.value(forKey: "accessibilityIdentifier") as? String,
			!identifier.isEmpty
		{
			identifiers.append(identifier)
		}
		if element.isAccessibilityElement {
			return identifiers
		}
		for child in accessibilityChildren(of: element) where !((child as? UIView)?.isHidden ?? false) {
			identifiers += accessibilityIdentifiers(in: child)
		}
		return identifiers
	}

	/// The element's children in the accessibility tree: its accessibility elements, or else a view's subviews.
	private func accessibilityChildren(of element: NSObject) -> [NSObject] {
		if let elements = element.accessibilityElements {
			return elements.compactMap { $0 as AnyObject as? NSObject }
		}
		let count = element.accessibilityElementCount()
		if count != NSNotFound, count > 0 {
			return (0 ..< count).compactMap { element.accessibilityElement(at: $0).flatMap { $0 as AnyObject as? NSObject } }
		}
		return (element as? UIView)?.subviews ?? []
	}
}

/// The accessibility mode UI tests run apps in, in which SwiftUI builds its accessibility tree without VoiceOver.
private struct AccessibilityAutomation {
	private let getEnabled: @convention(c) () -> Bool
	private let setEnabled: @convention(c) (Bool) -> Void

	init() throws {
		let handle = try #require(dlopen("/usr/lib/libAccessibility.dylib", RTLD_NOW))
		getEnabled = try unsafeBitCast(
			#require(dlsym(handle, "_AXSAutomationEnabled")),
			to: (@convention(c) () -> Bool).self,
		)
		setEnabled = try unsafeBitCast(
			#require(dlsym(handle, "_AXSSetAutomationEnabled")),
			to: (@convention(c) (Bool) -> Void).self,
		)
	}

	var isEnabled: Bool {
		get { getEnabled() }
		nonmutating set { setEnabled(newValue) }
	}
}

private final class NavigationModel: ObservableObject {
	@Published var isPushed = false
	var isCustomized = false
}

/// The layout from #376: a navigation view whose root has a customized horizontal scroll view, with accessibility
/// identifiers inside and on it.
private struct RootView: View {
	@ObservedObject var model: NavigationModel
	let introspection: AccessibilityTests.Introspection

	var body: some View {
		NavigationView {
			VStack {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						NavigationLink(
							destination: Text("Detail").accessibilityIdentifier("Detail"),
							isActive: $model.isPushed,
						) {
							Text("Item 0")
						}
						Text("Item 1")
					}
					.accessibilityIdentifier("Bar")
				}
				.modifier(ScrollViewIntrospection(model: model, introspection: introspection))
				.accessibilityElement(children: .contain)
				.accessibilityIdentifier("Foo")
				Spacer()
			}
		}
		.navigationViewStyle(.stack)
	}
}

private struct ScrollViewIntrospection: ViewModifier {
	let model: NavigationModel
	let introspection: AccessibilityTests.Introspection

	func body(content: Content) -> some View {
		switch introspection {
		case .none:
			content
		case .introspection:
			content.introspect(.scrollView, on: .iOS(.v13...), customize: customize)
		}
	}

	private static let delegate = PagingDelegate()

	/// The customization from #376.
	private func customize(_ scrollView: UIScrollView) {
		scrollView.decelerationRate = .fast
		scrollView.clipsToBounds = false
		scrollView.alwaysBounceVertical = false
		scrollView.delegate = Self.delegate
		model.isCustomized = true
	}
}

private final class PagingDelegate: NSObject, UIScrollViewDelegate {}

#endif
