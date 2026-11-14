#if os(iOS) || os(tvOS) || os(visionOS)
public import UIKit
#elseif os(macOS)
public import AppKit
#endif

@_spi(Advanced)
@MainActor
public struct IntrospectionSelector<Target: PlatformEntity> {
	@_spi(Advanced)
	public static var `default`: Self { .from(Target.self, selector: { $0 }) }

	@_spi(Advanced)
	public static func from<Entry: PlatformEntity>(
		_ entryType: Entry.Type,
		selector: @MainActor @escaping (Entry) -> Target?,
	) -> Self {
		.init(
			receiverSelector: { probe in
				probe.receiverEntity(ofType: Entry.self).flatMap(selector)
			},
			ancestorSelector: { probe in
				probe.ancestorEntity(ofType: Entry.self).flatMap(selector)
			},
		)
	}

	private(set) var probe: IntrospectionProbeKind = .viewController
	private var receiverSelector: @MainActor (any IntrospectionProbe) -> Target?
	private var ancestorSelector: @MainActor (any IntrospectionProbe) -> Target?

	func withProbe(_ probe: IntrospectionProbeKind) -> Self {
		var copy = self
		copy.probe = probe
		return copy
	}

	@_spi(Advanced)
	public func withReceiverSelector(_ selector: @MainActor @escaping (PlatformViewController) -> Target?) -> Self {
		var copy = self
		copy.receiverSelector = { $0.controller.flatMap(selector) }
		return copy
	}

	@_spi(Advanced)
	public func withAncestorSelector(_ selector: @MainActor @escaping (PlatformViewController) -> Target?) -> Self {
		var copy = self
		copy.ancestorSelector = { $0.controller.flatMap(selector) }
		return copy
	}

	func callAsFunction(_ probe: any IntrospectionProbe, _ scope: IntrospectionScope) -> Target? {
		if
			scope.contains(.receiver),
			let target = receiverSelector(probe)
		{
			return target
		}
		if
			scope.contains(.ancestor),
			let target = ancestorSelector(probe)
		{
			return target
		}
		return nil
	}
}

/// The kind of entity introspection inserts around the receiver to find its target.
enum IntrospectionProbeKind {
	/// A child view controller, which finds targets in both the view and view controller hierarchies.
	case viewController
	/// A view, which leaves the view controller hierarchy untouched and finds view controllers through the views they
	/// own. Use it for view controller targets whose behavior depends on their containment, such as a tab's navigation
	/// controller.
	case view
}

/// The entity introspection inserts in front of the receiver, from which selectors find their target.
@MainActor
protocol IntrospectionProbe: AnyObject {
	/// The view controller handed to custom selectors: the probe itself, or the view controller enclosing a view probe.
	var controller: PlatformViewController? { get }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry?
	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry?
}

extension IntrospectionPlatformViewController: IntrospectionProbe {
	var controller: PlatformViewController? { self }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		self.as(Entry.Base.self)?.receiver(ofType: Entry.self)
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		self.as(Entry.Base.self)?.ancestor(ofType: Entry.self)
	}
}

extension IntrospectionPlatformView: IntrospectionProbe {
	var controller: PlatformViewController? { enclosingController }

	func receiverEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return receiver(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			guard
				let anchor = introspectionAnchorEntity,
				let commonAncestor = anchor.nearestCommonAncestor(with: self),
				let container = commonAncestor.enclosingController
			else {
				return nil
			}
			let controllersByView = Dictionary(
				container.allDescendants.compactMap { controller in
					controller.loadedView.map { (ObjectIdentifier($0), controller) }
				},
				uniquingKeysWith: { first, _ in first },
			)
			return commonAncestor
				.allDescendants(between: anchor, and: self)
				.lazy
				.compactMap { controllersByView[ObjectIdentifier($0)] }
				.firstPlatformEntity(ofType: Entry.self)
		}
		return nil
	}

	func ancestorEntity<Entry: PlatformEntity>(ofType type: Entry.Type) -> Entry? {
		if Entry.Base.self == PlatformView.self {
			return ancestor(ofType: Entry.self)
		} else if Entry.Base.self == PlatformViewController.self {
			return enclosingController.flatMap {
				sequence(first: $0, next: \.parent).firstPlatformEntity(ofType: Entry.self)
			}
		}
		return nil
	}
}

extension PlatformViewController {
	func `as`<Base: PlatformEntity>(_ baseType: Base.Type) -> (any PlatformEntity)? {
		if Base.self == PlatformView.self {
			return loadedView
		} else if Base.self == PlatformViewController.self {
			return self
		}
		return nil
	}

	fileprivate var loadedView: PlatformView? {
		#if canImport(UIKit)
		viewIfLoaded
		#elseif canImport(AppKit)
		isViewLoaded ? view : nil
		#endif
	}
}

extension PlatformView {
	/// The innermost view controller whose view contains this view.
	///
	/// SwiftUI's hosting views take their controllers out of the responder chain, so this searches the view controller
	/// hierarchy from the window down instead.
	fileprivate var enclosingController: PlatformViewController? {
		#if canImport(UIKit)
		let roots = window?.rootViewController.map { Array(sequence(first: $0, next: \.presentedViewController)) } ?? []
		#elseif canImport(AppKit)
		let roots = window?.contentViewController.map { [$0] } ?? []
		#endif
		guard var controller = roots.last(where: isEnclosed(by:)) else {
			return nil
		}
		while let child = controller.children.first(where: isEnclosed(by:)) {
			controller = child
		}
		return controller
	}

	private func isEnclosed(by controller: PlatformViewController) -> Bool {
		controller.loadedView.map(isDescendant(of:)) ?? false
	}
}
