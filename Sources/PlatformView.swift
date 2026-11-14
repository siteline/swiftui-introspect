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
extension PlatformViewControllerRepresentable {
	#if canImport(UIKit)
	public func makeUIViewController(context: Context) -> ViewController {
		makePlatformViewController(context: context)
	}
	public func updateUIViewController(_ controller: ViewController, context: Context) {
		updatePlatformViewController(controller, context: context)
	}
	public static func dismantleUIViewController(_ controller: ViewController, coordinator: Coordinator) {
		dismantlePlatformViewController(controller, coordinator: coordinator)
	}
	#elseif canImport(AppKit)
	public func makeNSViewController(context: Context) -> ViewController {
		makePlatformViewController(context: context)
	}
	public func updateNSViewController(_ controller: ViewController, context: Context) {
		updatePlatformViewController(controller, context: context)
	}
	public static func dismantleNSViewController(_ controller: ViewController, coordinator: Coordinator) {
		dismantlePlatformViewController(controller, coordinator: coordinator)
	}
	#endif
}

#if canImport(UIKit)
typealias _PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
typealias _PlatformViewRepresentable = NSViewRepresentable
#endif

@MainActor
protocol PlatformViewRepresentable: _PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias RepresentedView = UIViewType
	#elseif canImport(AppKit)
	typealias RepresentedView = NSViewType
	#endif

	func makePlatformView(context: Context) -> RepresentedView
	func updatePlatformView(_ view: RepresentedView, context: Context)
	static func dismantlePlatformView(_ view: RepresentedView, coordinator: Coordinator)
}

extension PlatformViewRepresentable {
	#if canImport(UIKit)
	func makeUIView(context: Context) -> RepresentedView {
		makePlatformView(context: context)
	}
	func updateUIView(_ view: RepresentedView, context: Context) {
		updatePlatformView(view, context: context)
	}
	static func dismantleUIView(_ view: RepresentedView, coordinator: Coordinator) {
		dismantlePlatformView(view, coordinator: coordinator)
	}
	#elseif canImport(AppKit)
	func makeNSView(context: Context) -> RepresentedView {
		makePlatformView(context: context)
	}
	func updateNSView(_ view: RepresentedView, context: Context) {
		updatePlatformView(view, context: context)
	}
	static func dismantleNSView(_ view: RepresentedView, coordinator: Coordinator) {
		dismantlePlatformView(view, coordinator: coordinator)
	}
	#endif
}
