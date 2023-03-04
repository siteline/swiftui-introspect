//import SwiftUI
//
//// MARK: SwiftUI.NavigationStack
//
//@available(iOS, introduced: 16)
//@available(tvOS, introduced: 16)
//@available(macOS, introduced: 13)
//public struct NavigationStackType: ViewType {}
//
//@available(iOS, introduced: 16)
//@available(tvOS, introduced: 16)
//@available(macOS, introduced: 13)
//extension StaticMember where Base == NavigationStackType {
//    public static var navigationStack: Self { .init(base: .init()) }
//}
//
//// MARK: SwiftUI.List - iOS
//
//#if canImport(UIKit)
//import UIKit
//
////@available(iOS, introduced: 16)
//@available(iOS 16, *)
//extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == NavigationStackType, PlatformView == UINavigationController {
//    public static let v16 = Self(for: .v16) { customize in
//        UIKitIntrospectionViewController(
//            selector: { introspectionViewController in
//
//                // Search in ancestors
//                if let navigationController = introspectionViewController.navigationController {
//                    return navigationController
//                }
//
//                // Search in siblings
//                return Introspect.previousSibling(containing: UINavigationController.self, from: introspectionViewController)
//            },
//            customize: customize
//        )
//    }
//}
//#endif
//
//// TODO: tvOS and macOS
