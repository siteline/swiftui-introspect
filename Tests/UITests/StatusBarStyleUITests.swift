import XCTest

final class StatusBarStyleUITests: UITestCase {
    override var testCase: TestCase {
        .statusBarStyle
    }

    func test() throws {
        guard #unavailable(iOS 17) else {
            throw XCTSkip("SimulatorStatusMagic stopped working in iOS 17, so we can no longer consistently compare status bar screenshots")
        }
    }
}
