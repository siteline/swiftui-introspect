@_spi(Advanced) import SwiftUIIntrospect
import Testing

@Suite
struct WeakTests {
	final class Foo {}

	var strongFoo: Foo? = Foo()

	@Test func init_nil() {
		@Weak var weakFoo: Foo?
		#expect(weakFoo == nil)
	}

	@Test func init_nonNil() {
		@Weak var weakFoo: Foo? = strongFoo
		#expect(weakFoo === strongFoo)
	}

	@Test func assignment_nilToNil() {
		@Weak var weakFoo: Foo?
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func assignment_nilToNonNil() {
		@Weak var weakFoo: Foo?
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test func assignment_nonNilToNil() {
		@Weak var weakFoo: Foo? = strongFoo
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func assignment_nonNilToNonNil() {
		@Weak var weakFoo: Foo? = strongFoo
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test mutating func indirectAssignment_nonNilToNil() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = nil
		#expect(weakFoo == nil)
	}

	@Test mutating func indirectAssignment_nonNilToNonNil() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = Foo()
		#expect(weakFoo == nil)
	}
}
