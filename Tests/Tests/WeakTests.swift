@_spi(Advanced) import SwiftUIIntrospect
import Testing

struct WeakTests {
	final class Foo {}

	var strongFoo: Foo? = Foo()

	@Test func `init nil`() {
		@Weak var weakFoo: Foo?
		#expect(weakFoo == nil)
	}

	@Test func `init non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		#expect(weakFoo === strongFoo)
	}

	@Test func `assignment nil to nil`() {
		@Weak var weakFoo: Foo?
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func `assignment nil to non-nil`() {
		@Weak var weakFoo: Foo?
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test func `assignment non-nil to nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		weakFoo = nil
		#expect(weakFoo == nil)
	}

	@Test func `assignment non-nil to non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		let otherFoo = Foo()
		weakFoo = otherFoo
		#expect(weakFoo === otherFoo)
	}

	@Test mutating func `indirect assignment non-nil to nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = nil
		#expect(weakFoo == nil)
	}

	@Test mutating func `indirect assignment non-nil to non-nil`() {
		@Weak var weakFoo: Foo? = strongFoo
		strongFoo = Foo()
		#expect(weakFoo == nil)
	}
}
