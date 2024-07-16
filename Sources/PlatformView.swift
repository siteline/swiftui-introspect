#if !os(watchOS)
import SwiftUI

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
typealias _PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
typealias _PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif

@MainActor
protocol PlatformViewControllerRepresentable: _PlatformViewControllerRepresentable {
    #if canImport(UIKit)
    typealias ViewController = UIViewControllerType
    #elseif canImport(AppKit)
    typealias ViewController = NSViewControllerType
    #endif

    @MainActor func makePlatformViewController(context: Context) -> ViewController
    @MainActor func updatePlatformViewController(_ controller: ViewController, context: Context)
    @MainActor static func dismantlePlatformViewController(_ controller: ViewController, coordinator: Coordinator)
}

extension PlatformViewControllerRepresentable {
    #if canImport(UIKit)
    @MainActor func makeUIViewController(context: Context) -> ViewController {
        makePlatformViewController(context: context)
    }
    @MainActor func updateUIViewController(_ controller: ViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    @MainActor static func dismantleUIViewController(_ controller: ViewController, coordinator: Coordinator) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #elseif canImport(AppKit)
    @MainActor func makeNSViewController(context: Context) -> ViewController {
        makePlatformViewController(context: context)
    }
    @MainActor func updateNSViewController(_ controller: ViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    @MainActor static func dismantleNSViewController(_ controller: ViewController, coordinator: Coordinator) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #endif
}
#endif
