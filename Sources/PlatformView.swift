import SwiftUI

#if canImport(UIKit)
public typealias PlatformView = UIView
#elseif canImport(AppKit)
public typealias PlatformView = NSView
#endif

#if canImport(UIKit)
typealias PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
typealias PlatformViewRepresentable = NSViewRepresentable
#endif

#if canImport(UIKit)
typealias PlatformViewController = UIViewController
#elseif canImport(AppKit)
typealias PlatformViewController = NSViewController
#endif

#if canImport(UIKit)
typealias _PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
typealias _PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif

protocol PlatformViewControllerRepresentable: _PlatformViewControllerRepresentable {
    func makePlatformViewController(context: Context) -> IntrospectionPlatformViewController
    func updatePlatformViewController(_ controller: IntrospectionPlatformViewController, context: Context)
    static func dismantlePlatformViewController(_ controller: IntrospectionPlatformViewController, coordinator: ())
}

extension PlatformViewControllerRepresentable {
    #if canImport(UIKit)
    func makeUIViewController(context: Context) -> IntrospectionPlatformViewController {
        makePlatformViewController(context: context)
    }
    func updateUIViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    static func dismantleUIViewController(_ controller: IntrospectionPlatformViewController, coordinator: ()) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #elseif canImport(AppKit)
    func makeNSViewController(context: Context) -> IntrospectionPlatformViewController {
        makePlatformViewController(context: context)
    }
    func updateNSViewController(_ controller: IntrospectionPlatformViewController, context: Context) {
        updatePlatformViewController(controller, context: context)
    }
    static func dismantleNSViewController(_ controller: IntrospectionPlatformViewController, coordinator: Coordinator) {
        dismantlePlatformViewController(controller, coordinator: coordinator)
    }
    #endif
}
