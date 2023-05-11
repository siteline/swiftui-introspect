import SwiftUI

#if canImport(UIKit)
public typealias PlatformView = UIView
#elseif canImport(AppKit)
public typealias PlatformView = NSView
#endif

#if canImport(UIKit)
public typealias PlatformViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif

#if canImport(UIKit)
public typealias PlatformViewController = UIViewController
#elseif canImport(AppKit)
public typealias PlatformViewController = NSViewController
#endif

#if canImport(UIKit)
public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif canImport(AppKit)
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif
