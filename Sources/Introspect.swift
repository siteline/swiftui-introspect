public import SwiftUI

/// The scope of introspection i.e. where introspect should look to find
/// the desired target view relative to the applied `.introspect(...)`
/// modifier.
public struct IntrospectionScope: OptionSet, Sendable {
	/// Look within the `receiver` of the `.introspect(...)` modifier.
	public static let receiver = Self(rawValue: 1 << 0)
	/// Look for an `ancestor` relative to the `.introspect(...)` modifier.
	public static let ancestor = Self(rawValue: 1 << 1)

	@_spi(Internals) public let rawValue: UInt

	@_spi(Internals) public init(rawValue: UInt) {
		self.rawValue = rawValue
	}
}

extension View {
	/// Introspects a SwiftUI view to find its underlying UIKit/AppKit instance.
	///
	/// - Parameters:
	///   - viewType: The type of view to be introspected.
	///   - platforms: A list of version predicates that specify platform-specific entities associated with the view.
	///   - scope: Optionally overrides the view's default scope of introspection.
	///   - customize: A closure that hands over the underlying UIKit/AppKit instance ready for customization.
	///
	///     Note there is no guarantee of one-time execution for this closure. As `customize` may fire multiple times,
	///     make sure to guard against repeated or heavy work in your closure by keeping track of its completeness.
	///
	///     SwiftUI can call `.onAppear` and start `.task` before the platform view exists, so `customize` may run after
	///     them. Start work that depends on your customization from `customize` itself.
	///
	///     Additionally, note that mutating SwiftUI state within `customize` will trigger runtime warnings unless that
	///     mutation is wrapped in a `DispatchQueue.main.async { ... }` call. This is because introspect attempts to hand
	///     you the requested view as soon as possible, and this might mean SwiftUI isn't ready for state mutations at
	///     that particular moment.
	///
	/// Here's an example usage:
	///
	/// ```swift
	/// struct ContentView: View {
	///   @State var text = ""
	///
	///   var body: some View {
	///     TextField("Placeholder", text: $text)
	///       .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) {
	///         print(type(of: $0)) // UITextField
	///       }
	///   }
	/// }
	/// ```
	@MainActor
	public func introspect<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity>(
		_ viewType: SwiftUIViewType,
		on platforms: PlatformViewVersionPredicate<SwiftUIViewType, PlatformSpecificEntity>...,
		scope: IntrospectionScope? = nil,
		customize: @escaping (PlatformSpecificEntity) -> Void,
	) -> some View {
		self.modifier(IntrospectModifier(viewType, platforms: platforms, scope: scope, customize: customize))
	}
}

struct IntrospectModifier<
	SwiftUIViewType: IntrospectableViewType,
	PlatformSpecificEntity: PlatformEntity,
>: ViewModifier {
	@State private var anchorReference = IntrospectionAnchorReference()
	/// Whether a view probe found its target, so its anchor leaves the hierarchy, where it would hide the receiver from
	/// UIKit's search for a view controller's content scroll view.
	@State private var isAnchorRetired = false
	let scope: IntrospectionScope
	let selector: IntrospectionSelector<PlatformSpecificEntity>?
	let customize: (PlatformSpecificEntity) -> Void

	@MainActor
	init(
		_ viewType: SwiftUIViewType,
		platforms: [PlatformViewVersionPredicate<SwiftUIViewType, PlatformSpecificEntity>],
		scope: IntrospectionScope?,
		customize: @escaping (PlatformSpecificEntity) -> Void,
	) {
		self.scope = scope ?? viewType.scope
		// A loop rather than `compactMap(\.selector)`, whose generic key path is instantiated on every call.
		var selector: IntrospectionSelector<PlatformSpecificEntity>? = nil
		for platform in platforms {
			if let platformSelector = platform.selector {
				selector = platformSelector
				break
			}
		}
		self.selector = selector
		self.customize = customize
	}

	func body(content: Content) -> some View {
		if let selector {
			switch selector.probe {
			case .viewController:
				introspect(
					content,
					anchor: IntrospectionAnchorControllerRepresentable(anchorReference: anchorReference),
					needsAnchor: true,
					probe: IntrospectionProbeControllerRepresentable(
						anchorReference: anchorReference,
						selector: { selector($0, scope) },
						customize: customize,
					),
				)
			case .view:
				introspect(
					content,
					anchor: IntrospectionAnchorViewRepresentable(anchorReference: anchorReference),
					// only receiver searches start at a view anchor, and custom selectors never see one
					needsAnchor: scope.contains(.receiver) && !isAnchorRetired,
					probe: IntrospectionProbeViewRepresentable(
						anchorReference: anchorReference,
						isAnchorRetired: $isAnchorRetired,
						selector: { selector($0, scope) },
						customize: customize,
					),
				)
			}
		} else {
			content
		}
	}

	private func introspect(_ content: Content, anchor: some View, needsAnchor: Bool, probe: some View) -> some View {
		content
			.background(
				Group {
					// box up content for more accurate `.view` introspection
					if SwiftUIViewType.self == ViewType.self {
						Color.white
							.opacity(0)
							.accessibility(hidden: true)
					}
				},
			)
			.background(
				Group {
					if needsAnchor {
						anchor
							.frame(width: 0, height: 0)
							.accessibility(hidden: true)
					}
				},
			)
			.overlay(
				probe
					.frame(width: 0, height: 0)
					.accessibility(hidden: true),
			)
	}
}

@MainActor
public protocol PlatformEntity: AnyObject {
	associatedtype Base: PlatformEntity

	@_spi(Internals)
	var ancestor: Base? { get }

	@_spi(Internals)
	var descendants: [Base] { get }

	@_spi(Internals)
	func isDescendant(of other: Base) -> Bool
}

extension PlatformEntity {
	@_spi(Internals)
	public var ancestor: Base? { nil }

	@_spi(Internals)
	public var descendants: [Base] { [] }

	@_spi(Internals)
	public func isDescendant(of other: Base) -> Bool { false }
}

extension PlatformEntity where Base.Base == Base {
	@_spi(Internals)
	public var ancestors: some Sequence<Base> {
		sequence(state: Base?.none) { [self] entity in
			entity = entity == nil ? self.ancestor : entity?.ancestor
			return entity
		}
	}

	@_spi(Internals)
	public var allDescendants: some Sequence<Base> {
		PlatformEntityDescendants(of: self.descendants)
	}
}

extension PlatformEntity where Base == Self {
	func nearestCommonAncestor(with other: Self) -> Self? {
		var nearestAncestor: Self? = self

		while let currentEntity = nearestAncestor, !other.isDescendant(of: currentEntity) {
			nearestAncestor = currentEntity.ancestor
		}

		return nearestAncestor
	}

	/// This entity's descendants from the bottom entity up to the top one, in depth-first order. The traversal starts at
	/// the bottom entity, so it doesn't visit the descendants that come before it.
	func allDescendants(between bottomEntity: Self, and topEntity: Self) -> PlatformEntityDescendants<Self> {
		PlatformEntityDescendants(from: bottomEntity, to: topEntity, within: self)
	}

	/// The entities from the anchor up to this entity, in depth-first order, where receiver scope looks for its target.
	func receiverCandidates(after anchor: Self) -> PlatformEntityDescendants<Self> {
		guard let commonAncestor = anchor.nearestCommonAncestor(with: self) else {
			return PlatformEntityDescendants(of: [])
		}
		return commonAncestor.allDescendants(between: anchor, and: self)
	}
}

/// A depth-first traversal of entities, which reads an entity's descendants only once it moves past that entity.
@MainActor
struct PlatformEntityDescendants<Entity: PlatformEntity>: @MainActor Sequence, @MainActor IteratorProtocol
	where Entity.Base == Entity
{
	/// The entities left to visit at each depth, outermost first, each with the index of the next one to visit.
	private var levels: [(entities: [Entity], index: Int)]
	/// The entity last visited, whose descendants come next.
	private var lastVisited: Entity? = nil
	/// The entity that ends the traversal, if any.
	private let end: Entity?

	/// The given entities and their descendants.
	init(of entities: [Entity]) {
		self.levels = [(entities, 0)]
		self.end = nil
	}

	/// The given descendant of the root, its descendants, and the entities that follow them in the root's subtree, up to
	/// the end entity.
	init(from descendant: Entity, to end: Entity, within root: Entity) {
		self.end = end
		self.levels = []
		guard descendant !== root else {
			return
		}
		var levels = [(entities: [descendant], index: 0)]
		var entity = descendant
		while entity !== root {
			guard let parent = entity.ancestor else {
				return
			}
			let siblings = parent.descendants
			// A loop rather than `firstIndex(where:)`: every search runs this over all of a container's subviews, and the
			// closure would check its actor isolation on every call.
			var index = 0
			while index < siblings.count, siblings[index] !== entity {
				index += 1
			}
			if index < siblings.count {
				levels.append((siblings, index + 1))
			}
			entity = parent
		}
		self.levels = levels.reversed()
	}

	mutating func next() -> Entity? {
		if let lastVisited {
			self.lastVisited = nil
			let descendants = lastVisited.descendants
			if !descendants.isEmpty {
				levels.append((descendants, 0))
			}
		}
		while let depth = levels.indices.last {
			let index = levels[depth].index
			if index < levels[depth].entities.count {
				let entity = levels[depth].entities[index]
				if entity === end {
					levels = []
					return nil
				}
				levels[depth].index = index + 1
				lastVisited = entity
				return entity
			}
			levels.removeLast()
		}
		return nil
	}
}

extension Sequence where Element: PlatformEntity {
	/// The first entity of the given type that isn't introspection's own.
	///
	/// Always inlined, so that callers that are generic over the type still iterate a concrete sequence. Generic code
	/// that isn't specialized for its element type is several times slower to traverse a hierarchy.
	@MainActor
	@inline(__always)
	func firstPlatformEntity<PlatformSpecificEntity: PlatformEntity>(
		ofType type: PlatformSpecificEntity.Type,
	) -> PlatformSpecificEntity? {
		for entity in self {
			if let match = entity as? PlatformSpecificEntity, !entity.isIntrospectionPlatformEntity {
				return match
			}
		}
		return nil
	}
}

extension PlatformView: PlatformEntity {
	@_spi(Internals)
	public var ancestor: PlatformView? {
		superview
	}

	@_spi(Internals)
	public var descendants: [PlatformView] {
		subviews
	}
}

extension PlatformViewController: PlatformEntity {
	@_spi(Internals)
	public var ancestor: PlatformViewController? {
		parent
	}

	@_spi(Internals)
	public var descendants: [PlatformViewController] {
		children
	}

	@_spi(Internals)
	public func isDescendant(of other: PlatformViewController) -> Bool {
		self.ancestors.contains(other)
	}
}

#if canImport(UIKit)
extension UIPresentationController: PlatformEntity {
	public typealias Base = UIPresentationController
}
#elseif canImport(AppKit)
extension NSWindow: PlatformEntity {
	public typealias Base = NSWindow
}
#endif
