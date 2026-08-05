@testable import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct PlatformEntityTraversalTests {
	@Test func ancestorLookupStopsAfterFirstMatch() {
		let tail = Entity()
		let match = MatchingEntity(ancestor: tail)
		let entity = Entity(ancestor: match)

		#expect(entity.ancestor(ofType: MatchingEntity.self) === match)
		#expect(match.ancestorAccessCount == 0)
	}

	private class Entity: PlatformEntity {
		typealias Base = Entity

		private let storedAncestor: Entity?
		private(set) var ancestorAccessCount = 0

		init(ancestor: Entity? = nil) {
			self.storedAncestor = ancestor
		}

		var ancestor: Entity? {
			ancestorAccessCount += 1
			return storedAncestor
		}

		var descendants: [Entity] { [] }

		func isDescendant(of other: Entity) -> Bool { false }
	}

	private final class MatchingEntity: Entity {}
}
