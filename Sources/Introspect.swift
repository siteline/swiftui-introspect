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

extension PlatformView {
    var superviews: AnySequence<PlatformView> {
        return AnySequence<PlatformView>(
            sequence(first: self, next: { $0.superview }).dropFirst()
        )
    }
}

extension PlatformView {
//    public func findReceiver(ofType:from:)

    public func findReceiver<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type
    ) -> AnyViewType? {
        for superview in self.superviews {
            let children = superview.recursivelyFindSubviews(ofType: AnyViewType.self)

            for child in children {
                guard
                    let childFrame = child.superview?.convert(child.frame, to: superview),
                    let entryFrame = self.superview?.convert(self.frame, to: superview)
                else {
                    continue
                }
                
                if childFrame.contains(entryFrame) {
                    print(superview)
                    return child
                }
            }
        }
        return nil
    }

    func recursivelyFindSubviews<T: PlatformView>(ofType type: T.Type) -> [T] {
        var result = self.subviews.compactMap { $0 as? T }
        for sub in self.subviews {
            result.append( contentsOf: sub.recursivelyFindSubviews (ofType: type))
        }
        return result
    }
}


/// Utility methods to inspect the UIKit view hierarchy.
public enum Introspect {
    
    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        in root: PlatformView
    ) -> AnyViewType? {
        for subview in root.subviews {
            if let typed = subview as? AnyViewType {
                return typed
            } else if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        return nil
    }
    
    /// Finds a child view controller of the specified type.
    /// This method will recursively look for this child.
    /// Returns nil if it can't find a view of the specified type.
    public static func findChild<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        in root: PlatformViewController
    ) -> AnyViewControllerType? {
        for child in root.children {
            if let typed = child as? AnyViewControllerType {
                return typed
            } else if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }
        return root as? AnyViewControllerType
    }
    
    /// Finds a previous sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for subview in superview.subviews[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a previous sibling that is of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func previousSibling<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for subview in superview.subviews[0..<entryIndex].reversed() {
            if let typed = subview as? AnyViewType {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a previous sibling that contains a view controller of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    @available(macOS, unavailable)
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        containing type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {
        
        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = findChild(ofType: type, in: child) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a previous sibling that is a view controller of the specified type.
    /// This method does not inspect siblings recursively.
    /// Returns nil if no sibling is of the specified type.
    public static func previousSibling<AnyViewControllerType: PlatformViewController>(
        ofType type: AnyViewControllerType.Type,
        from entry: PlatformViewController
    ) -> AnyViewControllerType? {
        
        guard let parent = entry.parent,
            let entryIndex = parent.children.firstIndex(of: entry),
            entryIndex > 0
        else {
            return nil
        }
        
        for child in parent.children[0..<entryIndex].reversed() {
            if let typed = child as? AnyViewControllerType {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a next sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func nextSibling<AnyViewType: PlatformView>(
        containing type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }
        
        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            if let typed = findChild(ofType: type, in: subview) {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds a next sibling that if of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    public static func nextSibling<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        
        guard let superview = entry.superview,
            let entryIndex = superview.subviews.firstIndex(of: entry)
        else {
            return nil
        }
        
        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            if let typed = subview as? AnyViewType {
                return typed
            }
        }
        
        return nil
    }
    
    /// Finds an ancestor of the specified type.
    /// If it reaches the top of the view without finding the specified view type, it returns nil.
    public static func findAncestor<AnyViewType: PlatformView>(
        ofType type: AnyViewType.Type,
        from entry: PlatformView
    ) -> AnyViewType? {
        var superview = entry.superview
        while let s = superview {
            if let typed = s as? AnyViewType {
                return typed
            }
            superview = s.superview
        }
        return nil
    }
    
    /// Finds the hosting view of a specific subview.
    /// Hosting views generally contain subviews for one specific SwiftUI element.
    /// For instance, if there are multiple text fields in a VStack, the hosting view will contain those text fields (and their host views, see below).
    /// Returns nil if it couldn't find a hosting view. This should never happen when called with an IntrospectionView.
    public static func findHostingView(
        from entry: PlatformView
    ) -> PlatformView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("HostingView") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
    
    /// Finds the view host of a specific view.
    /// SwiftUI wraps each UIView within a ViewHost, then within a HostingView.
    /// Returns nil if it couldn't find a view host. This should never happen when called with an IntrospectionView.
    public static func findViewHost(
        from entry: PlatformView
    ) -> PlatformView? {
        var superview = entry.superview
        while let s = superview {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            superview = s.superview
        }
        return nil
    }
}

/// Allows to safely access an array element by index
/// Usage: array[safe: 2]
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}