@_spi(Advanced) import SwiftUIIntrospect
import Testing

@Suite
struct WeakTests {
    final class Foo {}

    var strongFoo: Foo? = Foo()

    @Test func Init_nil() {
        @Weak var weakFoo: Foo?
        #expect(weakFoo == nil)
    }

    @Test func Init_nonNil() {
        @Weak var weakFoo: Foo? = strongFoo
        #expect(weakFoo === strongFoo)
    }

    @Test func Assignment_nilToNil() {
        @Weak var weakFoo: Foo?
        weakFoo = nil
        #expect(weakFoo == nil)
    }

    @Test func Assignment_nilToNonNil() {
        @Weak var weakFoo: Foo?
        let otherFoo = Foo()
        weakFoo = otherFoo
        #expect(weakFoo === otherFoo)
    }

    @Test func Assignment_nonNilToNil() {
        @Weak var weakFoo: Foo? = strongFoo
        weakFoo = nil
        #expect(weakFoo == nil)
    }

    @Test func Assignment_nonNilToNonNil() {
        @Weak var weakFoo: Foo? = strongFoo
        let otherFoo = Foo()
        weakFoo = otherFoo
        #expect(weakFoo === otherFoo)
    }

    @Test mutating func IndirectAssignment_nonNilToNil() {
        @Weak var weakFoo: Foo? = strongFoo
        strongFoo = nil
        #expect(weakFoo == nil)
    }

    @Test mutating func IndirectAssignment_nonNilToNonNil() {
        @Weak var weakFoo: Foo? = strongFoo
        strongFoo = Foo()
        #expect(weakFoo == nil)
    }
}
