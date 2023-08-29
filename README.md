SwiftUI Introspect
=================

[![CI Status Badge](https://github.com/siteline/SwiftUI-Introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/siteline/SwiftUI-Introspect/actions/workflows/ci.yml)
[![Platform Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2FSwiftUI-Introspect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/siteline/SwiftUI-Introspect)

> **Note**
>
> [`SwiftUIIntrospect`](./Package@swift-5.7.swift#L14) is an all-new module based off the original [`Introspect`](./Package.swift#L13) module that improves on stability, predictability, and ergonomics.
>
> Both modules currently live together under this repo, but the plan is to ultimately obsolete `Introspect` in favor of `SwiftUIIntrospect` as part of a 1.0 release.
>
> While `Introspect` supports Swift 5.5 or higher, `SwiftUIIntrospect` requires Swift 5.7 or higher due to the use of more recent language features which partially enable the aforementioned improvements over the original.

SwiftUIIntrospect allows you to get the underlying UIKit or AppKit element of a SwiftUI view.

For instance, with SwiftUIIntrospect you can access `UITableView` to modify separators, or `UINavigationController` to customize the tab bar.

How it works
------------

SwiftUIIntrospect works by adding an invisible `IntrospectionView` on top of the selected view, and an invisible "anchor" view underneath it, then looking through the UIKit/AppKit view hierarchy between the two to find the relevant view.

For instance, when introspecting a `ScrollView`...

```swift
ScrollView {
    Text("Item 1")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
    // do something with UIScrollView
}
```

... it will:

1. Add marker views in front and behind `ScrollView`.
2. Traverse through all subviews between both marker views until a `UIScrollView` instance (if any) is found.

> **Warning**
>
> Although this introspection method is very solid and unlikely to break in itself, future OS releases require explicit opt-in for introspection (`.iOS(.vXYZ)`), given potential differences in underlying UIKit/AppKit view types between major OS versions.

By default, `.introspect` works directly on its _receiver_. This means calling `.introspect` from inside the view you're trying to introspect won't have any effect. This is different to the original `Introspect` module in which some views would implicitly allow introspection from within. This is because most of the time it's more stable and predictable to introspect views directly, but there are times when it's not possible or simply too inflexible for library developers. You **can** introspect an _ancestor_ with `SwiftUIIntrospect`, but you must opt into this explicitly by overriding the introspection `scope`:

```swift
ScrollView {
    Text("Item 1")
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17), scope: .ancestor) { scrollView in
            // do something with UIScrollView
        }
}
```

### Usage in production

`SwiftUIIntrospect` is meant to be used in production. It does not use any private API. It only inspects the view hierarchy using publicly available methods. The library takes a defensive approach to inspecting the view hierarchy: there is no hard assumption that elements are laid out a certain way, there is no force-cast to UIKit/AppKit classes, and the `.introspect` modifier is simply ignored if UIKit/AppKit views cannot be found.

Install
-------

### Swift Package Manager

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "0.12.0"),
    ],
    targets: [
        .target(name: <#Target Name#>, dependencies: [
            .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
        ]),
    ]
)
```

### CocoaPods

```ruby
pod 'SwiftUIIntrospect'
```

Introspection
-------------

### Implemented

- [`Button`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/buttontype)
- [`ColorPicker`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/colorpickertype)
- [`DatePicker`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickertype)
- [`DatePicker` with `.compact` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickerwithcompactstyletype)
- [`DatePicker` with `.field` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickerwithfieldstyletype)
- [`DatePicker` with `.graphical` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickerwithgraphicalstyletype)
- [`DatePicker` with `.stepperField` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickerwithstepperfieldstyletype)
- [`DatePicker` with `.wheel` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/datepickerwithwheelstyletype)
- [`Form`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/formtype)
- [`Form` with `.grouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/formwithgroupedstyletype)
- [`.fullScreenCover`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/fullScreenCovertype)
- [`List`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listtype)
- [`List` with `.bordered` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listwithborderedstyletype)
- [`List` with `.grouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listwithgroupedstyletype)
- [`List` with `.insetGrouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listwithinsetgroupedstyletype)
- [`List` with `.inset` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listwithinsetstyletype)
- [`List` with `.sidebar` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listwithsidebarstyletype)
- [`ListCell`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/listcelltype)
- [`Map`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/maptype)
- [`NavigationSplitView`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/navigationsplitviewtype)
- [`NavigationStack`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/navigationstacktype)
- [`NavigationView` with `.columns` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/NavigationViewWithColumnsStyleType)
- [`NavigationView` with `.stack` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/NavigationViewWithStackStyleType)
- [`PageControl`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/pagecontroltype)
- [`Picker` with `.menu` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/pickerwithmenustyletype)
- [`Picker` with `.segmented` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/pickerwithsegmentedstyletype)
- [`Picker` with `.wheel` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/pickerwithwheelstyletype)
- [`.popover`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/popovertype)
- [`ProgressView` with `.circular` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/progressviewwithcircularstyletype)
- [`ProgressView` with `.linear` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/progressviewwithlinearstyletype)
- [`ScrollView`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/scrollviewtype)
- [`.searchable`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/searchfieldtype)
- [`SecureField`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/securefieldtype)
- [`.sheet`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/sheettype)
- [`SignInWithAppleButton`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/SignInWithAppleButtonType)
- [`Slider`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/slidertype)
- [`Stepper`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/steppertype)
- [`Table`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/tabletype)
- [`TabView`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/tabviewtype)
- [`TabView` with `.page` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/TabViewWithPageStyleType)
- [`TextEditor`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/texteditortype)
- [`TextField`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/textfieldtype)
- [`TextField` with `.vertical` axis](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/TextFieldWithVerticalAxisType)
- [`Toggle`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/toggletype)
- [`Toggle` with `button` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/togglewithbuttonstyletype)
- [`Toggle` with `checkbox` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/togglewithcheckboxstyletype)
- [`Toggle` with `switch` style](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/togglewithswitchstyletype)
- [`VideoPlayer`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/videoplayertype)
- [`View`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/viewtype)
- [`ViewController`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/viewcontrollertype)
- [`Window`](https://swiftpackageindex.com/siteline/swiftui-introspect/master/documentation/swiftuiintrospect/windowtype)

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues). As a temporary solution, you can [implement your own introspectable view type](#implement-your-own-view-type).

### Cannot implement

SwiftUI | Affected Frameworks | Why
--- | --- | ---
Text | UIKit, AppKit | Not a UILabel / NSLabel
Image | UIKit, AppKit | Not a UIImageView / NSImageView
Button | UIKit | Not a UIButton

Examples
--------

### List

```swift
List {
    Text("Item")
}
.introspect(.list, on: .iOS(.v13, .v14, .v15)) { tableView in
    tableView.backgroundView = UIView()
    tableView.backgroundColor = .cyan
}
.introspect(.list, on: .iOS(.v16, .v17)) { collectionView in
    collectionView.backgroundView = UIView()
    collectionView.subviews.dropFirst(1).first?.backgroundColor = .cyan
}
```

### ScrollView

```swift
ScrollView {
    Text("Item")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
    scrollView.backgroundColor = .red
}
```

### NavigationView

```swift
NavigationView {
    Text("Item")
}
.navigationViewStyle(.stack)
.introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17)) { navigationController in
    navigationController.navigationBar.backgroundColor = .cyan
}
```

### TextField

```swift
TextField("Text Field", text: <#Binding<String>#>)
    .introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { textField in
        textField.backgroundColor = .red
    }
```

Advanced usage
--------------

### Implement your own introspectable type

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues).

In case SwiftUIIntrospect (unlikely) doesn't support the SwiftUI element that you're looking for, you can implement your own introspectable type.

For example, here's how the library implements the introspectable `TextField` type:

```swift
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

public struct TextFieldType: IntrospectableViewType {}

extension IntrospectableViewType where Self == TextFieldType {
    public static var textField: Self { .init() }
}

#if canImport(UIKit)
extension iOSViewVersion<TextFieldType, UITextField> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension tvOSViewVersion<TextFieldType, UITextField> {
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
    public static let v15 = Self(for: .v15)
    public static let v16 = Self(for: .v16)
    public static let v17 = Self(for: .v17)
}

extension visionOSViewVersion<TextFieldType, UITextField> {
    public static let v1 = Self(for: .v1)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldType, NSTextField> {
    public static let v10_15 = Self(for: .v10_15)
    public static let v11 = Self(for: .v11)
    public static let v12 = Self(for: .v12)
    public static let v13 = Self(for: .v13)
    public static let v14 = Self(for: .v14)
}
#endif
```

### Introspect on future platform versions

By default, introspection applies per specific platform version. This is a sensible default for maximum predictability in regularly maintained codebases, but it's not always a good fit for e.g. library developers who may want to cover as many future platform versions as possible in order to provide the best chance for long-term future functionality of their library without regular maintenance.

For such cases, SwiftUI Introspect offers range-based platform version predicates behind the Advanced SPI:

```swift
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ContentView: View {
    var body: some View {
        ScrollView {
            // ...
        }
        .introspect(.scrollView, on: .iOS(.v13...)) { scrollView in
            // ...
        }
    }
}
```

Bear in mind this should be used cautiosly, and with full knowledge that any future OS version might break the expected introspection types unless explicitly available. For instance, if in the example above hypothetically iOS 18 stops using UIScrollView under the hood, the customization closure will never be called on said platform.

### Keep instances outside the customize closure

Sometimes, you might need to keep your introspected instance around for longer than the customization closure lifetime. In such cases, `@State` is not a good option because it produces retain cycles. Instead, SwiftUI Introspect offers a `@Weak` property wrapper behind the Advanced SPI:

```swift
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ContentView: View {
    @Weak var scrollView: UIScrollView?

    var body: some View {
        ScrollView {
            // ...
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
            self.scrollView = scrollView
        }
    }
}
```

Community projects
------------------

Here's a list of open source libraries powered by the SwiftUI Introspect library:

- [CustomKeyboardKit](https://github.com/paescebu/CustomKeyboardKit)
- [NavigationTransitions](https://github.com/davdroman/swiftui-navigation-transitions)

If you're working on a library built on SwiftUI Introspect or know of one, feel free to submit a PR adding it to the list.
