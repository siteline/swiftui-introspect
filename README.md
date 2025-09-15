SwiftUI Introspect
=================

[![CI Status Badge](https://github.com/siteline/swiftui-introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/siteline/swiftui-introspect/actions/workflows/ci.yml)
[![Swift Version Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2Fswiftui-introspect%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/siteline/swiftui-introspect)
[![Platform Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2Fswiftui-introspect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/siteline/swiftui-introspect)

SwiftUI Introspect allows you to get the underlying UIKit or AppKit element of a SwiftUI view.

For instance, with SwiftUI Introspect you can access `UITableView` to modify separators, or `UINavigationController` to customize the tab bar.

- [How it works](#how-it-works)
- [Install](#install)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
- [View Types](#view-types)
- [Examples](#examples)
- [General Guidelines](#general-guidelines)
- [Advanced usage](#advanced-usage)
    - [Implement your own introspectable type](#implement-your-own-introspectable-type)
    - [Introspect on future platform versions](#introspect-on-future-platform-versions)
    - [Keep instances outside the customize closure](#keep-instances-outside-the-customize-closure)
- [Note for library maintainers](#note-for-library-maintainers)
- [Community projects](#community-projects)

How it works
------------

SwiftUI Introspect works by adding an invisible `IntrospectionView` on top of the selected view, and an invisible "anchor" view underneath it, then looking through the UIKit/AppKit view hierarchy between the two to find the relevant view.

For instance, when introspecting a `ScrollView`...

```swift
ScrollView {
	Text("Item 1")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
	// do something with UIScrollView
}
```

... it will:

1. Add marker views in front and behind `ScrollView`.
2. Traverse through all subviews between both marker views until a `UIScrollView` instance (if any) is found.

> [!IMPORTANT]
> Although this introspection method is very solid and unlikely to break in itself, future OS releases require explicit opt-in for introspection (`.iOS(.vXYZ)`), given potential differences in underlying UIKit/AppKit view types between major OS versions.

By default, the `.introspect` modifier acts directly on its _receiver_. This means calling `.introspect` from inside the view you're trying to introspect won't have any effect. However, there are times when this is not possible or simply too inflexible, in which case you **can** introspect an _ancestor_, but you must opt into this explicitly by overriding the introspection `scope`:

```swift
ScrollView {
	Text("Item 1")
		.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor) { scrollView in
			// do something with UIScrollView
		}
}
```

### Usage in production

SwiftUI Introspect is meant to be used in production. It does not use any private API. It only inspects the view hierarchy using publicly available methods. The library takes a defensive approach to inspecting the view hierarchy: there is no hard assumption that elements are laid out a certain way, there is no force-cast to UIKit/AppKit classes, and the `.introspect` modifier is simply ignored if UIKit/AppKit views cannot be found.

Install
-------

### Swift Package Manager

#### Xcode

<img width="660" height="300" src="https://github.com/user-attachments/assets/ab1c1a62-96d9-417d-ad2b-43012a69cae8" />

#### Package.swift

```swift
let package = Package(
	dependencies: [
		.package(url: "https://github.com/siteline/swiftui-introspect", from: "26.0.0"),
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
pod 'SwiftUIIntrospect', '~> 26.0.0'
```

View Types
----------

### Implemented

- [`Button`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/buttontype)
- [`ColorPicker`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/colorpickertype)
- [`DatePicker`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickertype)
- [`DatePicker` with `.compact` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickerwithcompactstyletype)
- [`DatePicker` with `.field` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickerwithfieldstyletype)
- [`DatePicker` with `.graphical` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickerwithgraphicalstyletype)
- [`DatePicker` with `.stepperField` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickerwithstepperfieldstyletype)
- [`DatePicker` with `.wheel` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/datepickerwithwheelstyletype)
- [`Form`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/formtype)
- [`Form` with `.grouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/formwithgroupedstyletype)
- [`.fullScreenCover`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/fullScreenCovertype)
- [`List`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listtype)
- [`List` with `.bordered` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listwithborderedstyletype)
- [`List` with `.grouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listwithgroupedstyletype)
- [`List` with `.insetGrouped` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listwithinsetgroupedstyletype)
- [`List` with `.inset` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listwithinsetstyletype)
- [`List` with `.sidebar` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listwithsidebarstyletype)
- [`ListCell`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/listcelltype)
- [`Map`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/maptype)
- [`NavigationSplitView`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/navigationsplitviewtype)
- [`NavigationStack`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/navigationstacktype)
- [`NavigationView` with `.columns` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/NavigationViewWithColumnsStyleType)
- [`NavigationView` with `.stack` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/NavigationViewWithStackStyleType)
- [`PageControl`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/pagecontroltype)
- [`Picker` with `.menu` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/pickerwithmenustyletype)
- [`Picker` with `.segmented` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/pickerwithsegmentedstyletype)
- [`Picker` with `.wheel` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/pickerwithwheelstyletype)
- [`.popover`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/popovertype)
- [`ProgressView` with `.circular` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/progressviewwithcircularstyletype)
- [`ProgressView` with `.linear` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/progressviewwithlinearstyletype)
- [`ScrollView`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/scrollviewtype)
- [`.searchable`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/searchfieldtype)
- [`SecureField`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/securefieldtype)
- [`.sheet`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/sheettype)
- [`Slider`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/slidertype)
- [`Stepper`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/steppertype)
- [`Table`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/tabletype)
- [`TabView`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/tabviewtype)
- [`TabView` with `.page` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/TabViewWithPageStyleType)
- [`TextEditor`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/texteditortype)
- [`TextField`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/textfieldtype)
- [`TextField` with `.vertical` axis](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/TextFieldWithVerticalAxisType)
- [`Toggle`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/toggletype)
- [`Toggle` with `button` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/togglewithbuttonstyletype)
- [`Toggle` with `checkbox` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/togglewithcheckboxstyletype)
- [`Toggle` with `switch` style](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/togglewithswitchstyletype)
- [`VideoPlayer`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/videoplayertype)
- [`View`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/viewtype)
- [`ViewController`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/viewcontrollertype)
- [`WebView`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/webviewtype)
- [`Window`](https://swiftpackageindex.com/siteline/swiftui-introspect/main/documentation/swiftuiintrospect/windowtype)

**Missing an element?** Please [start a discussion](https://github.com/siteline/swiftui-introspect/discussions/new?category=ideas). As a temporary solution, you can [implement your own introspectable view type](#implement-your-own-introspectable-type).

### Cannot implement

SwiftUI | Affected Frameworks | Why
--- | --- | ---
Text | UIKit, AppKit | Not a UILabel / NSLabel
Image | UIKit, AppKit | Not a UIImageView / NSImageView
Button | UIKit | Not a UIButton
Link | UIKit, AppKit | Not a UIButton / NSButton
NavigationLink | UIKit | Not a UIButton
GroupBox | AppKit | No underlying view
Menu | UIKit, AppKit | No underlying view
Spacer | UIKit, AppKit | No underlying view
Divider | UIKit, AppKit | No underlying view
HStack, VStack, ZStack | UIKit, AppKit | No underlying view
LazyVStack, LazyHStack, LazyVGrid, LazyHGrid | UIKit, AppKit | No underlying view
Color | UIKit, AppKit | No underlying view
ForEach | UIKit, AppKit | No underlying view
GeometryReader | UIKit, AppKit | No underlying view
Chart | UIKit, AppKit | Native SwiftUI framework

Examples
--------

### List

```swift
List {
	Text("Item")
}
.introspect(.list, on: .iOS(.v13, .v14, .v15)) { tableView in
	tableView.bounces = false
}
.introspect(.list, on: .iOS(.v16, .v17, .v18, .v26)) { collectionView in
	collectionView.bounces = false
}
```

### ScrollView

```swift
ScrollView {
	Text("Item")
}
.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
	scrollView.bounces = false
}
```

### NavigationView

```swift
NavigationView {
	Text("Item")
}
.navigationViewStyle(.stack)
.introspect(.navigationView(style: .stack), on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { navigationController in
	navigationController.navigationBar.backgroundColor = .cyan
}
```

### TextField

```swift
TextField("Text Field", text: <#Binding<String>#>)
	.introspect(.textField, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { textField in
		textField.backgroundColor = .red
	}
```

General Guidelines
------------------

Here are some guidelines to keep in mind when using SwiftUI Introspect:

- **Use sparingly**: introspection should be a last resort when you need to access underlying UIKit/AppKit components that SwiftUI does not expose. Overusing it can lead to fragile code that may break with future SwiftUI updates. As Apple introduces new modifiers to SwiftUI, consider replacing introspection with native SwiftUI solutions.
- **Program defensively**: the introspection closure may be called multiple times during the view's lifecycle, such as during view updates or re-renders. Ensure that your customization code can handle being executed multiple times without causing unintended side effects.
- **Do not modify state directly**: avoid changing SwiftUI state directly from within the introspection closure. If you need to update state, enclose it within a `DispatchQueue.main.async` block to ensure it happens within safe SwiftUI update cycles.
- **Test on all target OS versions**: since SwiftUI Introspect relies on the underlying view hierarchy, it's crucial to test your app on all the OS versions you intend to support. Different OS versions may have different underlying implementations, which can affect introspection.
- **Avoid retain cycles**: be cautious about capturing `self` or other strong references within the introspection closure, as this can lead to memory leaks. Use `[weak self]` or `[unowned self]` capture lists as appropriate.
- **Use the correct scope**: by default, the `.introspect` modifier acts on its receiver. If you need to introspect an ancestor view, make sure to set the `scope` parameter to `.ancestor`. In general, you won't need to worry about this as each view type has sensible, predictable scope defaults.

Advanced usage
--------------

> [!NOTE]
> The following features are considered advanced and are not necessary for most use cases. They are provided for users who need more control or flexibility when using SwiftUI Introspect.

> [!IMPORTANT]
> To access these features, import SwiftUI Introspect using `@_spi(Advanced)` (see examples below).

### Implement your own introspectable type

**Missing an element?** Please [start a discussion](https://github.com/siteline/swiftui-introspect/discussions/new?category=ideas).

In case SwiftUI Introspect (unlikely) doesn't support the SwiftUI element that you're looking for, you can implement your own introspectable type.

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
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension tvOSViewVersion<TextFieldType, UITextField> {
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v16 = Self(for: .v16)
	public static let v17 = Self(for: .v17)
	public static let v18 = Self(for: .v18)
	public static let v26 = Self(for: .v26)
}

extension visionOSViewVersion<TextFieldType, UITextField> {
	public static let v1 = Self(for: .v1)
	public static let v2 = Self(for: .v2)
	public static let v26 = Self(for: .v26)
}
#elseif canImport(AppKit)
extension macOSViewVersion<TextFieldType, NSTextField> {
	public static let v10_15 = Self(for: .v10_15)
	public static let v11 = Self(for: .v11)
	public static let v12 = Self(for: .v12)
	public static let v13 = Self(for: .v13)
	public static let v14 = Self(for: .v14)
	public static let v15 = Self(for: .v15)
	public static let v26 = Self(for: .v26)
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

Bear in mind this should be used cautiously, and with full knowledge that any future OS version might break the expected introspection types unless explicitly available. For instance, if in the example above hypothetically iOS 19 stops using UIScrollView under the hood, the customization closure will never be called on said platform.

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
		.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
			self.scrollView = scrollView
		}
	}
}
```

Note for library maintainers
----------------------------

If your library depends on SwiftUI Introspect, declare your dependency with a version range that spans at least the **last two major versions** rather than bumping straight to the latest one. This avoids conflicts when apps depend on SwiftUI Introspect directly or through multiple libraries at once. For example:

```swift
.package(url: "https://github.com/siteline/swiftui-introspect", "1.3.0"..<"27.0.0"),
```

Supporting a wider range is safe because SwiftUI Introspect is essentially a “finished” library: no new features will be added, only support for newer platform versions. Thanks to [`@_spi(Advanced)` imports](https://github.com/siteline/swiftui-introspect#introspect-on-future-platform-versions), it’s already future-proofed without requiring frequent version bumps.

Community projects
------------------

Here's a list of open source libraries powered by the SwiftUI Introspect library:

<a href="https://github.com/paescebu/CustomKeyboardKit">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=paescebu&repo=CustomKeyboardKit" />
</a>

<a href="https://github.com/davdroman/swiftui-navigation-transitions">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=davdroman&repo=swiftui-navigation-transitions" />
</a>

If you're working on a library built on SwiftUI Introspect or know of one, feel free to submit a PR adding it to the list.
