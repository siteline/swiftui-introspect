Introspect for SwiftUI
======================

[![CircleCI](https://circleci.com/gh/timbersoftware/SwiftUI-Introspect.svg?style=svg&circle-token=6f995f204d4d417d31f79e7257f6e1ecf430ae07)](https://circleci.com/gh/timbersoftware/SwiftUI-Introspect)

Introspect allows you to get the underlying UIKit element of a SwiftUI view.

For instance, with Introspect you can access `UITableView` to modify separators, or `UINavigationController` to customize the tab bar.

How it works
------------

Introspect works by adding a custom `IntrospectionView` to the view hierarchy, then looking into the UIKit hierarchy to find the relevant view.

![](./docs/diagram.png)

For instance, when introspecting a `TextField`, it will:

 - Add `IntrospectionView` as an overlay of `TextField`
 - Get the view host of the introspection view (which is alongside the view host of the `UITextField`)
 - Get the previous sibling containing `UITextField`

**Please note that this introspection method might break in future SwiftUI releases.** Future implementations might not use the same hierarchy, or might not use UIKit elements that are being looked for. Though the library is unlikely to crash, the `.introspect()` method will not be called in those cases.

### Usage in production

`Introspect` is meant to be used in production. It does not use any private API. It only inspects the view hierarchy using publicly available methods. The library takes a defensive approach to inspecting the view hierarchy: there is no hard assumption that elements are laid out a certain way, there is no force-cast to UIKit classes, and the `introspect()` methods are simply ignored if UIKit views cannot be found.


Install
-------

### SwiftPM

```
https://github.com/timbersoftware/SwiftUI-Introspect.git
```

### Cocoapods

```
pod "Introspect"
```

Introspection
-------------

### Implemented

SwiftUI | UIKit | Introspect | Target
--- | --- | --- | ---
List | UITableView | `.introspectTableView()` | List, or List child
ScrollView | UIScrollView | `.introspectScrollView()` | ScrollView, or ScrollView child
NavigationView | UINavigationController | `.introspectNavigationController()` | NavigationView, or NavigationView child
_Any embedded view_ | UIViewController | `.introspectViewController()` | View embedded in a view controller
TabView | UITabBarController | `.introspectTabBarController()` | TabView, or TabView child
TextField | UITextField | `.introspectTextField()` | TextField
Toggle | UISwitch | `.introspectSwitch()` | Toggle
Slider | UISlider | `.introspectSlider()` | Slider
Stepper | UIStepper | `.introspectStepper()` | Stepper
DatePicker | UIDatePicker | `.introspectDatePicker()` | DatePicker
Picker (SegmentedPickerStyle) | UISegmentedControl | `.introspectSegmentedControl()` | Picker

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues). As a temporary solution, you can [implement your own selector](#implement-your-own-selector).

### Cannot implement

SwiftUI | Why
--- | ---
Text | Not a UILabel
Image | Not a UIImageView
Button | Not a UIButton

Examples
--------

### List

```swift
List {
    Text("Item 1")
    Text("Item 2")
}
.introspectTableView { tableView in
    tableView.separatorStyle = .none
}
```

### ScrollView

```swift
ScrollView {
    Text("Item 2")
}
.introspectScrollView { scrollView in
    scrollView.refreshControl = UIRefreshControl()
}
```

### NavigationView

```swift
NavigationView {
    Text("Item 2")
    .introspectNavigationController { navigationController in
        navigationController.navigationBar.backgroundColor = .red
    }
}
```

### TextField

```swift
TextField("Text Field", text: $textFieldValue)
.introspectTextField { textField in
    textField.layer.backgroundColor = UIColor.red.cgColor
}
```

Implement your own selector
---------------------------

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues).

In case Introspect doesn't support the SwiftUI element that you're looking for, you can implement your own selector. For example, to look for a `UITextField`:

```swift
extension View {
    public func introspectTextField(customize: @escaping (UITextField) -> ()) -> some View {
        return inject(IntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: UITextField.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
```

You can use any of the following [methods](https://github.com/timbersoftware/SwiftUI-Introspect/blob/master/Introspect/Introspect.swift#L3-L71) to inspect the hierarchy:

 - `Introspect.findChild(ofType:in:)`
 - `Introspect.previousSibling(containing:from:)`
 - `Introspect.nextSibling(containing:from:)`
 - `Introspect.findAncestor(ofType:from:)`
 - `Introspect.findHostingView(from:)`
 - `Introspect.findViewHost(from:)`
