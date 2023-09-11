import SwiftUI

@_spi(Advanced)
@propertyWrapper
public final class Weak<T: AnyObject>: ObservableObject {
    private weak var _wrappedValue: T? {
        willSet {
            objectWillChange.send()
        }
    }

    public var wrappedValue: T? {
        get { _wrappedValue }
        set { _wrappedValue = newValue }
    }

    public init(wrappedValue: T? = nil) {
        self._wrappedValue = wrappedValue
    }
}
