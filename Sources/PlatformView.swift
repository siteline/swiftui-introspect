import SwiftUI

#if os(macOS)
public typealias PlatformView = NSView
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformView = UIView
#endif

#if os(macOS)
public typealias PlatformViewRepresentable = NSViewRepresentable
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif

#if os(macOS)
public typealias PlatformViewController = NSViewController
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewController = UIViewController
#endif

#if os(macOS)
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif
#if os(iOS) || os(tvOS)
public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#endif
