import SwiftUI
import XCTest

#if canImport(UIKit)
enum TestUtils {
    private static let window = UIWindow(frame: UIScreen.main.bounds)

    static func present(view: some View) {
        window.rootViewController = UIHostingController(rootView: view)
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
    }
}
#elseif canImport(AppKit)
enum TestUtils {
    private static let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered,
        defer: true
    )

    static func present(view: some View) {
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        window.layoutIfNeeded()
    }
}
#endif

func XCTAssertViewIntrospection<V: View, PV: AnyObject>(
    of type: PV.Type,
    @ViewBuilder view: (Spies<PV>) -> V,
    extraAssertions: ([PV]) -> Void = { _ in },
    file: StaticString = #file,
    line: UInt = #line
) {
    let spies = Spies<PV>()
    let view = view(spies)
    TestUtils.present(view: view)
    XCTWaiter(delegate: spies).wait(for: spies.expectations.values.map(\.0), timeout: 3)
    extraAssertions(spies.objects.sorted(by: { $0.key < $1.key }).map(\.value))
}

final class Spies<PV: AnyObject>: NSObject, XCTWaiterDelegate {
    private(set) var objects: [Int: PV] = [:]
    private(set) var expectations: [ObjectIdentifier: (XCTestExpectation, StaticString, UInt)] = [:]

    subscript(
        number: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (PV) -> Void {
        let expectation = XCTestExpectation()
        expectations[ObjectIdentifier(expectation)] = (expectation, file, line)
        return { [self] in
            if let object = objects[number] {
                XCTAssert(object === $0, "Found view was overriden by another view", file: file, line: line)
            }
            objects[number] = $0
            expectation.fulfill()
        }
    }

    func waiter(
        _ waiter: XCTWaiter,
        didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]
    ) {
        for expectation in unfulfilledExpectations {
            let (_, file, line) = expectations[ObjectIdentifier(expectation)]!
            XCTFail("Spy not called", file: file, line: line)
        }
    }

    func nestedWaiter(
        _ waiter: XCTWaiter,
        wasInterruptedByTimedOutWaiter outerWaiter: XCTWaiter
    ) {
        XCTFail("wasInterruptedByTimedOutWaiter")
    }

    func waiter(
        _ waiter: XCTWaiter,
        fulfillmentDidViolateOrderingConstraintsFor expectation: XCTestExpectation,
        requiredExpectation: XCTestExpectation
    ) {
        XCTFail("fulfillmentDidViolateOrderingConstraintsFor")
    }

    func waiter(
        _ waiter: XCTWaiter,
        didFulfillInvertedExpectation expectation: XCTestExpectation
    ) {
        XCTFail("didFulfillInvertedExpectation")
    }
}

extension Collection {
    subscript(safe index: Index, file: StaticString = #file, line: UInt = #line) -> Element? {
        get {
            guard indices.contains(index) else {
                XCTFail("Index \(index) is out of bounds", file: file, line: line)
                return nil
            }
            return self[index]
        }
    }
}
