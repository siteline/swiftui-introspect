import SwiftUI
import SwiftUIIntrospect
import XCTest

final class NavigationViewWithColumnsStyleTests: XCTestCase {
    #if canImport(UIKit) && os(iOS)
    typealias PlatformNavigationViewWithColumnsStyle = UISplitViewController
    #elseif canImport(UIKit) && os(tvOS)
    typealias PlatformNavigationViewWithColumnsStyle = UINavigationController
    #elseif canImport(AppKit)
    typealias PlatformNavigationViewWithColumnsStyle = NSSplitView
    #endif

    func testNavigationViewWithColumnsStyleAsReceiver() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithColumnsStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            #if os(iOS)
            .introspect(.navigationViewWithColumnsStyle, on: .iOS(.v13, .v14, .v15, .v16), customize: spy)
            #elseif os(tvOS)
            .introspect(.navigationViewWithColumnsStyle, on: .tvOS(.v13, .v14, .v15, .v16), customize: spy)
            #elseif os(macOS)
            .introspect(.navigationViewWithColumnsStyle, on: .macOS(.v10_15, .v11, .v12, .v13), customize: spy)
            #endif
        }
    }

    func testNavigationViewWithColumnsStyleAsAncestor() {
        XCTAssertViewIntrospection(of: PlatformNavigationViewWithColumnsStyle.self) { spies in
            let spy = spies[0]

            NavigationView {
                ZStack {
                    Color.red
                    Text("Something")
                        #if os(iOS)
                        .introspect(.navigationViewWithColumnsStyle, on: .iOS(.v13, .v14, .v15, .v16), customize: spy)
                        #elseif os(tvOS)
                        .introspect(.navigationViewWithColumnsStyle, on: .tvOS(.v13, .v14, .v15, .v16), customize: spy)
                        #elseif os(macOS)
                        .introspect(.navigationViewWithColumnsStyle, on: .macOS(.v10_15, .v11, .v12, .v13), customize: spy)
                        #endif
                }
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}
