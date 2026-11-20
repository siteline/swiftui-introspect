import SwiftUI
import Testing
@_spi(Internals) @testable import SwiftUIIntrospect

@MainActor
struct PlatformEntityTraversalTests {
	@Test func `ancestor lookup stops after first match`() {
		let match = MatchingEntity(ancestor: Entity())
		let entity = Entity(ancestor: match)

		#expect(entity.ancestors.firstPlatformEntity(ofType: MatchingEntity.self) === match)
		#expect(match.ancestorAccessCount == 0)
	}

	@Test func `bounded descendant lookup stops after first match`() {
		let back = Entity()
		let match = MatchingEntity()
		let tail = Entity()
		let front = Entity()
		let root = Entity(descendants: [back, match, tail, front])

		let result = root
			.allDescendants(between: back, and: front)
			.firstPlatformEntity(ofType: MatchingEntity.self)

		#expect(result === match)
		#expect(tail.descendantsAccessCount == 0)
	}

	@Test func `bounded descendant lookup starts at the back entity`() {
		let head = Entity(descendants: [Entity()])
		let back = Entity()
		let match = MatchingEntity()
		let front = Entity()
		let root = Entity(descendants: [head, Entity(descendants: [back]), match, front])

		let result = root
			.allDescendants(between: back, and: front)
			.firstPlatformEntity(ofType: MatchingEntity.self)

		#expect(result === match)
		#expect(head.descendantsAccessCount == 0)
	}

	@Test func `bounded descendant lookup stops at the front entity`() {
		let back = Entity()
		let front = Entity()
		let root = Entity(descendants: [back, Entity(), front, MatchingEntity()])

		let result = root
			.allDescendants(between: back, and: front)
			.firstPlatformEntity(ofType: MatchingEntity.self)

		#expect(result == nil)
		#expect(front.descendantsAccessCount == 0)
	}

	@Test func `descendant lookup stops after first match`() {
		let match = MatchingEntity()
		let tail = Entity()
		let root = Entity(descendants: [Entity(), match, tail])
		let descendants = root.allDescendants

		#expect(descendants.firstPlatformEntity(ofType: MatchingEntity.self) === match)
		#expect(tail.descendantsAccessCount == 0)
	}

	@Test func `lookup skips introspection entities`() {
		let marker = MarkerEntity()
		let match = MatchingEntity()
		let entities: [Entity] = [marker, match]

		#expect(entities.firstPlatformEntity(ofType: MatchingEntity.self) === match)
	}

	@Test func `lookup skips the views of introspection view controllers`() {
		let controller = IntrospectionAnchorController(anchorReference: IntrospectionAnchorReference())

		#expect(controller.view.isIntrospectionPlatformEntity)
		#expect(!PlatformView().isIntrospectionPlatformEntity)
	}

	private class Entity: PlatformEntity {
		typealias Base = Entity

		private var storedAncestor: Entity? = nil
		private let storedDescendants: [Entity]
		private(set) var ancestorAccessCount = 0
		private(set) var descendantsAccessCount = 0

		init(ancestor: Entity? = nil, descendants: [Entity] = []) {
			self.storedAncestor = ancestor
			self.storedDescendants = descendants
			for descendant in descendants {
				descendant.storedAncestor = self
			}
		}

		var ancestor: Entity? {
			ancestorAccessCount += 1
			return storedAncestor
		}

		var descendants: [Entity] {
			descendantsAccessCount += 1
			return storedDescendants
		}

		func isDescendant(of other: Entity) -> Bool { false }
	}

	private class MatchingEntity: Entity {}

	private final class MarkerEntity: MatchingEntity, IntrospectionPlatformEntity {}
}
