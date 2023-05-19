//import SwiftUI
//@testable import SwiftUIIntrospect
//import XCTest
//
//final class IntrospectTests: XCTestCase {
//    func testFindReceiver() {
//        final class TargetView: PlatformView {}
//
//        let grandparent = PlatformView(frame: .init(x: 0, y: 0, width: 300, height: 300))
//
//        let parent = PlatformView(frame: .init(x: 100, y: 100, width: 100, height: 100)); grandparent.addSubview(parent)
//
//        let a = TargetView(frame: .init(x: 0, y: 0, width: 50, height: 50)); parent.addSubview(a)
//        let b = TargetView(frame: .init(x: 50, y: 0, width: 50, height: 50)); parent.addSubview(b)
//        let c = TargetView(frame: .init(x: 0, y: 50, width: 50, height: 50)); parent.addSubview(c)
//        let d = TargetView(frame: .init(x: 50, y: 50, width: 50, height: 50)); parent.addSubview(d)
//
//        let ai = PlatformView(frame: .init(x: 25, y: 25, width: 0, height: 0)); parent.addSubview(ai)
//        let bi = PlatformView(frame: .init(x: 75, y: 25, width: 0, height: 0)); parent.addSubview(bi)
//        let ci = PlatformView(frame: .init(x: 25, y: 75, width: 0, height: 0)); parent.addSubview(ci)
//        let di = PlatformView(frame: .init(x: 75, y: 75, width: 0, height: 0)); parent.addSubview(di)
//
//        XCTAssert(a === ai.findReceiver(ofType: TargetView.self))
//        XCTAssert(b === bi.findReceiver(ofType: TargetView.self))
//        XCTAssert(c === ci.findReceiver(ofType: TargetView.self))
//        XCTAssert(d === di.findReceiver(ofType: TargetView.self))
//    }
//}
