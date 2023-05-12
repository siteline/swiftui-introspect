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
public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif
