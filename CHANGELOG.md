Changelog
=========

## master

## [0.2.3]

- Fixed: `introspectPagedTabView` on iOS 16 (#200)
- Infrastructure: auto-deploy to CocoaPods (#201)

## [0.2.2]

- Hotfix: #192 (#196)

## [0.2.1]

- Fixed: memory leak in #161 and regression in #194 (#192)

## [0.2.0]

- Added: `introspectCollectionView/introspectCollectionViewCell` (#169)
- Added: `introspectSearchController` (#129)
- Added: `introspectPagedTabView` (#117)
- Added: `introspectMapView` (#125)
- Added: `introspectSplitView` on macOS (#100)
- Added: explicitly static/dynamic SPM library products (#168)
- Fixed: view controller introspection (#165)
- Fixed: issue where introspecting within a LazyVStack would silently fail #153
- Infrastructure: test coverage now spans iOS/tvOS 14/15/16 and macOS 11/12 (#185)
- Infrastructure: removed CircleCI in favor of GitHub Actions (#182, #183)

## [0.1.4]

- Added `.introspectSplitViewController()` on iOS
- Fixed iPad tests
- Added iPad to CI
- Added `.introspectColorWell()` on iOS and macOS
- Added `.introspectButton()` on macOS
- Fix UITextField with cornerRadius
- Added `.introspectTabView()` on macOS

## [0.1.3]

- Added `introspectTableViewCell`
- Add Github Action
- Added `.introspectTextView()`.
- Update CircleCI config to use Xcode 12.4.0
- Fixed nested `ScrollView` detection on iOS 14 and macOS 11

## [0.1.2]

 - Allow iOS 11, tvOS 11, macOS 10.13 as deployment target with SPM.
   [#41](https://github.com/siteline/SwiftUI-Introspect/pull/41)

## [0.1.1]

 - Allow `Introspect` to be imported in apps that support older platform versions.
 - Added Catalyst support in the Introspect iOS framework.
 - Fixed `.introspectScrollView()` on iOS 14
   [#55](https://github.com/siteline/SwiftUI-Introspect/issues/55)
 - Fixed availability annotations on macOS
   [#46](https://github.com/siteline/SwiftUI-Introspect/issues/46)

## [0.1.0]

 - Added `macOS` and `tvOS` support.

## [0.0.6]

 - Added `.introspectSegmentedControl()`.
 - Added `.introspectViewController()`.

## [0.0.5]

 - Allow `.introspectNavigationController()` on NavigationView directly.
 - Allow `.introspectTabBarController()` on TabView directly.

## [0.0.4]

 - Fix a bug in 0.0.4 that would not allow customization of root elements.

## [0.0.3]

 - Use `.overlay()` instead of `.background()` to not mess with list views.
   [#2](https://github.com/timbersoftware/SwiftUI-Introspect/issues/2)

## [0.0.2]

 - Added documentation for all methods.

## [0.0.1]

 - First release.

[0.2.0]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.2.0
[0.1.3]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.1.3
[0.1.2]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.1.2
[0.1.1]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.1.1
[0.1.0]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.1.0
[0.0.6]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.6
[0.0.5]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.5
[0.0.4]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.4
[0.0.3]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.3
[0.0.2]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.2
[0.0.1]: https://github.com/timbersoftware/SwiftUI-Introspect/releases/tag/0.0.1
