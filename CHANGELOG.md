Changelog
=========

## master

- Infrastructure: removed min iOS version constraint for UI Tests (#343)

## [0.12.0]

- Added: `@Weak` property wrapper (#341)
- Documentation: added advanced usage section to README (#341)
- Documentation: added community projects section to README (#342)

## [0.11.1]

- Fixed: `@_spi` errors (#339)

## [0.11.0]

- Added: visionOS support (#327)
- Infrastructure: run CI tests on iOS & tvOS 17 (#323)

## [0.10.0]

- Added: `SecureField` introspection (#317)

## [0.9.2]

- Fixed: occasionally wrong status bar style (#313)
- Infrastructure: added UI Test suite (#314)
- Infrastructure: disabled "Autocreate schemes" (#308)

## [0.9.1]

- Fixed: only box up content for `.view` introspection (#305)

## [0.9.0]

- Added: view controller introspection (#298)
- Added: page control introspection (#297)

## [0.8.0]

- Added: `Map` introspection (#288)
- Added: advanced range-based platform version predicates (#285)
- Changed: renamed `@_spi(Internals)` to `@_spi(Advanced)` (#290)
- Documentation: generate docs for extensions (#282)
- Infrastructure: set up `tea` for CI and local environments (#276)

## [0.7.0]

### SwiftUIIntrospect

- Added: window introspection (#269)
- Added: `.sheet` introspection (#268)
- Added: `.fullScreenCover` introspection (#268)
- Added: `.popover` introspection (#268)
- Added: `VideoPlayer` introspection (#264)
- Added: `SignInWithAppleButton` introspection (#265)
- Added: `View` introspection on macOS (#266)
- Improved: `View` introspection accuracy (#266)
- Documentation: added some more docs for public symbols (#273)

### Introspect

This module is now deprecated (#272) and will be removed later this year (whenever iOS/tvOS 17 come out).

## [0.6.3]

### SwiftUIIntrospect

- Changed: disabled accessibility for introspection views (#261)
- Documentation: code samples are now split by OS (#262)
- Infrastructure: use [`xcodes`](https://github.com/XcodesOrg/xcodes) via [`tea`](https://github.com/teaxyz/cli) on CI (#261)

## [0.6.2]

### SwiftUIIntrospect

- Documentation: added docs for all view types (#258)
- Infrastructure: fixed iOS/tvOS 13 checks on CI (#257)

## [0.6.1]

### SwiftUIIntrospect

- Improved: optimized receiver lookup algorithm (#246)
- Infrastructure: refactored `.introspect` to use `ViewModifier` (#253)
- Infrastructure: retry runtime download on timeout or error on CI (#247)

## [0.6.0]

### SwiftUIIntrospect

- Added: iOS 17 / tvOS 17 / macOS 14 compatibility (#243)

### Introspect

- Fixed: `UIColorWell` build error on tvOS 13 (#217)

## [0.5.2]

### SwiftUIIntrospect

- Added: selector overrides (#239)
- Changed: optimized ancestor controller selectors (#240)

## [0.5.1]

### SwiftUIIntrospect

- Fixed: SwiftUIIntrospect.podspec (#237)

## [0.5.0]

### SwiftUIIntrospect

- Added: support for custom selectors (#233)
- Changed: unified introspect modifiers into one (#232)
- Fixed: `searchField` introspection (#234)
- Documentation: added explicit SPI import (#229)

## [0.4.0]

- Added: all-new implementation, API, and module (SwiftUIIntrospect) (#207)

## [0.3.1]

- Fixed: wrong Swift version in podspec (#220)

## [0.3.0]

- Changed: minimum language version required is now Swift 5.5 (#209)
- Fixed: finding UIScrollViews that are clipped(), masked or combined with clipShape() or cornerRadius() (#213)
- Documentation: UICollectionView introspection support in README (#218)
- Infrastructure: symlink older SDKs to use in newer Xcode versions on CI (#208)

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
