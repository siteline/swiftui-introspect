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
@_spi(Internals)
public typealias _PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
@_spi(Internals)
public typealias _PlatformViewRepresentable = NSViewRepresentable
#endif

@MainActor
@_spi(Internals)
public protocol PlatformViewRepresentable: _PlatformViewRepresentable {
	#if canImport(UIKit)
	typealias View = UIViewType
	#elseif canImport(AppKit)
	typealias View = NSViewType
	#endif

	func makePlatformView(context: Context) -> View
	func updatePlatformView(_ view: View, context: Context)
	static func dismantlePlatformView(_ view: View, coordinator: Coordinator)
}

@_spi(Internals)
extension PlatformViewRepresentable {
	#if canImport(UIKit)
	public func makeUIView(context: Context) -> View {
		makePlatformView(context: context)
	}
	public func updateUIView(_ view: View, context: Context) {
		updatePlatformView(view, context: context)
	}
	public static func dismantleUIView(_ view: View, coordinator: Coordinator) {
		dismantlePlatformView(view, coordinator: coordinator)
	}
	#elseif canImport(AppKit)
	public func makeNSView(context: Context) -> View {
		makePlatformView(context: context)
	}
	public func updateNSView(_ view: View, context: Context) {
		updatePlatformView(view, context: context)
	}
	public static func dismantleNSView(_ view: View, coordinator: Coordinator) {
		dismantlePlatformView(view, coordinator: coordinator)
	}
	#endif
}
