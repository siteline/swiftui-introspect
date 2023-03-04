//import SwiftUI
//
//// MARK: SwiftUI.List
//
//public struct ListType: ViewType {}
//
//extension StaticMember where Base == ListType {
//    public static var list: Self { .init(base: .init()) }
//}
//
//// MARK: SwiftUI.List - iOS
//
//#if canImport(UIKit)
//import UIKit
//
//extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == ListType, PlatformView == UITableView {
//    public static let v13 = Self(for: .v13) { customize in
//        UIKitIntrospectionView(
//            selector: TargetViewSelector.ancestorOrSiblingContaining,
//            customize: customize
//        )
//    }
//    public static let v14 = Self(for: .v14, sameAs: .v13)
//    public static let v15 = Self(for: .v15, sameAs: .v13)
//}
//
//extension PlatformVersionDescriptor where Version == iOSVersion, SwiftUIView == ListType, PlatformView == UICollectionView {
//    public static let v16 = Self(for: .v16) { customize in
//        UIKitIntrospectionView(
//            selector: TargetViewSelector.ancestorOrSiblingContaining,
//            customize: customize
//        )
//    }
//}
//#endif
//
//// MARK: SwiftUI.List - tvOS
//
//#if canImport(UIKit)
//import UIKit
//
//extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == ListType, PlatformView == UITableView {
//    public static let v13 = Self(for: .v13) { customize in
//        UIKitIntrospectionView(
//            selector: TargetViewSelector.ancestorOrSiblingContaining,
//            customize: customize
//        )
//    }
//    public static let v14 = Self(for: .v14, sameAs: .v13)
//    public static let v15 = Self(for: .v15, sameAs: .v13)
//}
//
//extension PlatformVersionDescriptor where Version == tvOSVersion, SwiftUIView == ListType, PlatformView == UICollectionView {
//    @available(*, unavailable, message: "SwiftUI.List is no longer a UIKit view on iOS 16")
//    public static let v16 = unavailable(for: .v16)
//}
//#endif
//
//// MARK: SwiftUI.List - macOS
//
//#if canImport(AppKit) && !targetEnvironment(macCatalyst)
//import AppKit
//
//extension PlatformVersionDescriptor where Version == macOSVersion, SwiftUIView == ListType, PlatformView == NSTableView {
//    public static let v10_15 = Self(for: .v10_15) { customize in
//        AppKitIntrospectionView(
//            selector: TargetViewSelector.ancestorOrSiblingContaining,
//            customize: customize
//        )
//    }
//    public static let v11 = Self(for: .v11, sameAs: .v10_15)
//    public static let v12 = Self(for: .v12, sameAs: .v10_15)
//    public static let v13 = Self(for: .v13, sameAs: .v10_15)
//}
//#endif
