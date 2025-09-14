#if !os(watchOS)
public import SwiftUI

#if canImport(UIKit)
public typealias PlatformView = UIView
#elseif canImport(AppKit)
public typealias PlatformView = NSView
#endif

#if canImport(UIKit)
public typealias PlatformViewController = UIViewController
#elseif canImport(AppKit)
public typealias PlatformViewController = NSViewController
#endif

#if canImport(UIKit)
@_spi(Internals)
public typealias _PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
@_spi(Internals)
public typealias _PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif

@MainActor
@_spi(Internals)
public protocol PlatformViewControllerRepresentable: _PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	typealias ViewController = UIViewControllerType
	#elseif canImport(AppKit)
	typealias ViewController = NSViewControllerType
	#endif

	func makePlatformViewController(context: Context) -> ViewController
	func updatePlatformViewController(_ controller: ViewController, context: Context)
	static func dismantlePlatformViewController(_ controller: ViewController, coordinator: Coordinator)
}

@_spi(Internals)
public extension PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	func makeUIViewController(context: Context) -> ViewController {
		makePlatformViewController(context: context)
	}
	func updateUIViewController(_ controller: ViewController, context: Context) {
		updatePlatformViewController(controller, context: context)
	}
	static func dismantleUIViewController(_ controller: ViewController, coordinator: Coordinator) {
		dismantlePlatformViewController(controller, coordinator: coordinator)
	}
	#elseif canImport(AppKit)
	func makeNSViewController(context: Context) -> ViewController {
		makePlatformViewController(context: context)
	}
	func updateNSViewController(_ controller: ViewController, context: Context) {
		updatePlatformViewController(controller, context: context)
	}
	static func dismantleNSViewController(_ controller: ViewController, coordinator: Coordinator) {
		dismantlePlatformViewController(controller, coordinator: coordinator)
	}
	#endif
}
#endif
