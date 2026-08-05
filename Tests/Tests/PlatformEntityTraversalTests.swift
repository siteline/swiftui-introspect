@_spi(Internals) @testable import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PlatformEntityTraversalTests {
	@Test func ancestorLookupStopsAfterFirstMatch() {
		let match = MatchingEntity(ancestor: Entity())
		let entity = Entity(ancestor: match)

		#expect(entity.ancestor(ofType: MatchingEntity.self) === match)
		#expect(match.ancestorAccessCount == 0)
	}

	@Test func boundedDescendantLookupStopsAfterFirstMatch() {
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

	@Test func descendantLookupStopsAfterFirstMatch() {
		let match = MatchingEntity()
		let tail = Entity()
		let root = Entity(descendants: [Entity(), match, tail])
		let descendants = root.allDescendants

		#expect(descendants.firstPlatformEntity(ofType: MatchingEntity.self) === match)
		#expect(tail.descendantsAccessCount == 0)
	}

	@Test func lookupSkipsIntrospectionEntities() {
		let marker = MatchingEntity()
		let match = MatchingEntity()
		let entities: [Entity] = [marker, match]
		marker.isIntrospectionPlatformEntity = true

		#expect(entities.firstPlatformEntity(ofType: MatchingEntity.self) === match)
	}

	private class Entity: PlatformEntity {
		typealias Base = Entity

		private let storedAncestor: Entity?
		private let storedDescendants: [Entity]
		private(set) var ancestorAccessCount = 0
		private(set) var descendantsAccessCount = 0

		init(ancestor: Entity? = nil, descendants: [Entity] = []) {
			self.storedAncestor = ancestor
			self.storedDescendants = descendants
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

	private final class MatchingEntity: Entity {}
}
