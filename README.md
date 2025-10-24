SwiftUI Introspect
=================

[![CI Status Badge](https://github.com/siteline/swiftui-introspect/actions/workflows/ci.yml/badge.svg)](https://github.com/siteline/swiftui-introspect/actions/workflows/ci.yml)
[![Swift Version Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2Fswiftui-introspect%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/siteline/swiftui-introspect)
[![Platform Compatibility Badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsiteline%2Fswiftui-introspect%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/siteline/swiftui-introspect)

SwiftUI Introspect lets you access the underlying UIKit or AppKit view for a SwiftUI view.

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
- [Note for library authors](#note-for-library-authors)
- [Community projects](#community-projects)

How it works
------------

SwiftUI Introspect adds an invisible `IntrospectionView` above the selected view and an invisible anchor below it, then searches the UIKit/AppKit view hierarchy between them to find the relevant view.

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

1. Add marker views before and after `ScrollView`.
2. Traverse through all subviews between both marker views until a `UIScrollView` instance (if any) is found.

> [!IMPORTANT]
> Although this method is solid and unlikely to break on its own, future OS releases require explicit opt in for introspection (`.iOS(.vXYZ)`) because underlying UIKit/AppKit types can change between major versions.

By default, `.introspect` acts on its receiver. Calling `.introspect` from inside the view you want to introspect has no effect. If you need to introspect an ancestor instead, set `scope: .ancestor`:

```swift
ScrollView {
	Text("Item 1")
		.introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor) { scrollView in
			// do something with UIScrollView
		}
}
```

### Usage in production

SwiftUI Introspect is suitable for production. It does not use private APIs. It inspects the view hierarchy using public methods and takes a defensive approach: it makes no hard layout assumptions, performs no forced casts to UIKit/AppKit classes, and ignores `.introspect` when the expected UIKit/AppKit view cannot be found.

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

- **Use sparingly**: prefer native SwiftUI modifiers when available. Use introspection only when you need underlying UIKit/AppKit APIs that SwiftUI does not expose.
- **Program defensively**: the introspection closure may be called multiple times during the view's lifecycle, such as during view updates or re-renders. Ensure that your customization code can handle being executed multiple times without causing unintended side effects.
- **Avoid direct state changes**: do not change SwiftUI state from inside the introspection closure. If you must update state, wrap it in `DispatchQueue.main.async`.
- **Test across OS versions**: underlying implementations can differ by OS, which can affect customization.
- **Avoid retain cycles**: be cautious about capturing `self` or other strong references within the introspection closure, as this can lead to memory leaks. Use `[weak self]` or `[unowned self]` capture lists as appropriate.
- **Scope**: `.introspect` targets its receiver by default. Use `scope: .ancestor` only when you need to introspect an ancestor. In general, you shouldn't worry about this as each view type has sensible, predictable default scopes.

Advanced usage
--------------

> [!NOTE]
> These features are advanced and unnecessary for most use cases. Use them when you need extra control or flexibility.

> [!IMPORTANT]
> To access these features, import SwiftUI Introspect using `@_spi(Advanced)` (see examples below).

### Implement your own introspectable type

**Missing an element?** Please [start a discussion](https://github.com/siteline/swiftui-introspect/discussions/new?category=ideas).

In the unlikely event SwiftUI Introspect does not support the element you need, you can implement your own introspectable type.

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

By default, introspection targets specific platform versions. This is an intentional design decision to maintain maximum predictability in actively maintained apps. However library authors may prefer to cover future versions to limit their commitment to regular maintenance without breaking client apps. For that, SwiftUI Introspect provides range-based version predicates via the Advanced SPI:

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

Use this cautiously. Future OS versions may change underlying types, in which case the customization closure will not run unless support is explicitly declared.

### Keep instances outside the customize closure

Sometimes you need to keep an introspected instance beyond the customization closure. `@State` is not appropriate for this, as it can create retain cycles. Instead, SwiftUI Introspect offers a `@Weak` property wrapper behind the Advanced SPI:

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

Note for library authors
------------------------

If your library depends on SwiftUI Introspect, declare a version range that spans at least the **last two major versions** instead of jumping straight to the latest. This avoids conflicts when apps pull the library directly and through multiple dependencies. For example:

```swift
.package(url: "https://github.com/siteline/swiftui-introspect", "1.3.0"..<"27.0.0"),
```

A wider range is safe because SwiftUI Introspect is essentially “finished”: no new features will be added, only newer platform versions and view types. Thanks to [`@_spi(Advanced)` imports](https://github.com/siteline/swiftui-introspect#introspect-on-future-platform-versions), it is already future proof without frequent version bumps.

Community projects
------------------

Here are some popular open source libraries powered by SwiftUI Introspect:

<a href="https://github.com/paescebu/CustomKeyboardKit">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=paescebu&repo=CustomKeyboardKit" />
</a>

<a href="https://github.com/davdroman/swiftui-navigation-transitions">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=davdroman&repo=swiftui-navigation-transitions" />
</a>

<a href="https://github.com/exyte/PopupView">
  <img src="https://github-readme-stats.vercel.app/api/pin/?username=exyte&repo=PopupView" />
</a>

If you're working on a library built on SwiftUI Introspect or know of one, feel free to submit a PR adding it to the list.
