import SwiftUI
import SwiftUIIntrospect

struct ControlsShowcase: View {
	@State private var textFieldValue = ""
	@State private var toggleValue = false
	@State private var sliderValue = 0.0
	@State private var datePickerValue = Date()
	@State private var segmentedControlValue = 0

	var body: some View {
		VStack {
			HStack {
				TextField("Text Field Red", text: $textFieldValue)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.textField,
						on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
					) { textField in
						textField.backgroundColor = .red
					}
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { textField in
						textField.backgroundColor = .red
					}
					#endif

				TextField("Text Field Green", text: $textFieldValue)
					.cornerRadius(8)
					#if os(iOS) || os(tvOS) || os(visionOS)
					.introspect(
						.textField,
						on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
					) { textField in
						textField.backgroundColor = .green
					}
					#elseif os(macOS)
					.introspect(.textField, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { textField in
						textField.backgroundColor = .green
					}
					#endif
			}

			#if !os(tvOS)
			#if !os(visionOS)
			HStack {
				Toggle("Toggle Red", isOn: $toggleValue)
					#if os(iOS)
					.introspect(
						.toggle,
						on: .iOS(.v15, .v16, .v17, .v18, .v26)
					) { toggle in
						toggle.backgroundColor = .red
					}
					#elseif os(macOS)
					.introspect(.toggle, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { toggle in
						toggle.layer?.backgroundColor = NSColor.red.cgColor
					}
					#endif

				Toggle("Toggle Green", isOn: $toggleValue)
					#if os(iOS)
					.introspect(
						.toggle,
						on: .iOS(.v15, .v16, .v17, .v18, .v26)
					) { toggle in
						toggle.backgroundColor = .green
					}
					#elseif os(macOS)
					.introspect(.toggle, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { toggle in
						toggle.layer?.backgroundColor = NSColor.green.cgColor
					}
					#endif
			}

			#if !targetEnvironment(macCatalyst)
			HStack {
				Slider(value: $sliderValue, in: 0...100)
					#if os(iOS)
					.introspect(.slider, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { slider in
						slider.backgroundColor = .red
					}
					#elseif os(macOS)
					.introspect(.slider, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { slider in
						slider.layer?.backgroundColor = NSColor.red.cgColor
					}
					#endif

				Slider(value: $sliderValue, in: 0...100)
					#if os(iOS)
					.introspect(.slider, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { slider in
						slider.backgroundColor = .green
					}
					#elseif os(macOS)
					.introspect(.slider, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { slider in
						slider.layer?.backgroundColor = NSColor.green.cgColor
					}
					#endif
			}
			#endif

			HStack {
				Stepper(onIncrement: {}, onDecrement: {}) {
					Text("Stepper Red")
				}
				#if os(iOS)
				.introspect(.stepper, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { stepper in
					stepper.backgroundColor = .red
				}
				#elseif os(macOS)
				.introspect(.stepper, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { stepper in
					stepper.layer?.backgroundColor = NSColor.red.cgColor
				}
				#endif

				Stepper(onIncrement: {}, onDecrement: {}) {
					Text("Stepper Green")
				}
				#if os(iOS)
				.introspect(.stepper, on: .iOS(.v15, .v16, .v17, .v18, .v26)) { stepper in
					stepper.backgroundColor = .green
				}
				#elseif os(macOS)
				.introspect(.stepper, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { stepper in
					stepper.layer?.backgroundColor = NSColor.green.cgColor
				}
				#endif
			}
			#endif

			HStack {
				DatePicker(selection: $datePickerValue) {
					Text("DatePicker Red")
				}
				#if os(iOS) || os(visionOS)
				.introspect(.datePicker, on: .iOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)) { datePicker in
					datePicker.backgroundColor = .red
				}
				#elseif os(macOS)
				.introspect(.datePicker, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { datePicker in
					datePicker.layer?.backgroundColor = NSColor.red.cgColor
				}
				#endif
			}
			#endif

			HStack {
				Picker(selection: $segmentedControlValue, label: Text("Segmented control")) {
					Text("Option 1").tag(0)
					Text("Option 2").tag(1)
					Text("Option 3").tag(2)
				}
				.pickerStyle(SegmentedPickerStyle())
				#if os(iOS) || os(tvOS) || os(visionOS)
				.introspect(
					.picker(style: .segmented),
					on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
				) { datePicker in
					datePicker.backgroundColor = .red
				}
				#elseif os(macOS)
				.introspect(.picker(style: .segmented), on: .macOS(.v12, .v13, .v14, .v15, .v26)) { datePicker in
					datePicker.layer?.backgroundColor = NSColor.red.cgColor
				}
				#endif
			}
		}
	}
}
