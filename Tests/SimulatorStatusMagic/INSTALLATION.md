## Installing with Cocoapods

SimulatorStatusMagic is available through [CocoaPods](http://cocoapods.org). To install, simply add the following line to your Podfile:

```ruby
pod 'SimulatorStatusMagic', :configurations => ['Debug']
```

## Installing with Carthage

SimlatorStatusMagic is also available through [Carthage](https://github.com/Carthage/Carthage). Carthage will not make any modifications to your project, so installation is more involved than with CocoaPods. This describes a way of adding `SimulatorStatusMagic` so that it is only imported for `DEBUG` build configurations.

1. Add `SimulatorStatusMagic` to your `Cartfile`:
```
github "shinydevelopment/SimulatorStatusMagic"
```
2. Run `carthage update SimulatorStatusMagic --platform iOS`
3. Add the framework file directly from `Carthage/Build/iOS/` to `Linked Frameworks and Libraries`, **NOT** Embedded Libraries. Ensure that the file is reference at this location so that future `carthage update` builds will be embedded correctly.

![Linked Frameworks and Libraries](Artwork/linked-frameworks.png)

4. Add the `embed-debug-only-framework.sh` script found [here](https://gist.github.com/kenthumphries/cf04683184217c7331f9c213c556c65a) and discussed [here](https://github.com/shinydevelopment/SimulatorStatusMagic/blob/master/INSTALLATION.md).

![Embed run script phase](Artwork/run-script-phase.png)

5. Add code referencing `SimulatorStatusMagiciOS` inside `#if canImport ... #endif` blocks in your `AppDelegate`:
```swift
#if DEBUG
  import SimulatorStatusMagiciOS
#endif

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
    #if DEBUG
      SDStatusBarManager.sharedInstance()?.enableOverrides()
    #endif
  }
}
```

6. Run your app in `DEBUG` to see the status bar changes in effect.
