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

	private var explicitProbe: IntrospectionProbeKind? = nil
	private var hasCustomSelector = false
	private var receiverSelector: @MainActor (any IntrospectionProbe) -> Target?
	private var ancestorSelector: @MainActor (any IntrospectionProbe) -> Target?

	/// The probe set with `withProbe(_:)`, or else views on UIKit and view controllers on AppKit. Custom selectors also
	/// default to view controllers, since they receive the probe.
	var probe: IntrospectionProbeKind {
		if let explicitProbe {
			return explicitProbe
		}
		#if canImport(UIKit)
		return hasCustomSelector ? .viewController : .view
		#elseif canImport(AppKit)
		return .viewController
		#endif
	}

	func withProbe(_ probe: IntrospectionProbeKind) -> Self {
		var copy = self
		copy.explicitProbe = probe
		return copy
	}

	@_spi(Advanced)
	public func withReceiverSelector(_ selector: @MainActor @escaping (PlatformViewController) -> Target?) -> Self {
		var copy = self
		copy.hasCustomSelector = true
		copy.receiverSelector = { $0.controller.flatMap(selector) }
		return copy
	}

	@_spi(Advanced)
	public func withAncestorSelector(_ selector: @MainActor @escaping (PlatformViewController) -> Target?) -> Self {
		var copy = self
		copy.hasCustomSelector = true
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

extension PlatformViewController {
	func `as`<Base: PlatformEntity>(_ baseType: Base.Type) -> (any PlatformEntity)? {
		if Base.self == PlatformView.self {
			return loadedView
		} else if Base.self == PlatformViewController.self {
			return self
		}
		return nil
	}
}
