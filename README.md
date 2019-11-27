Introspect for SwiftUI
======================

Introspect allows you to get the underlying UIKit element of a SwiftUI view.

For instance, with Introspect you can access `UITableView` to modify separators, or `UINavigationController` to customize the tab bar.

How it works
------------

Introspect works by adding a custom `IntrospectionView` to the view hierarchy, then looking into the UIKit hierarchy to find the relevant view.

For instance, when introspecting a `TextField`, it will:

 - Add `IntrospectionView` as the background of `TextField`
 - Get the view host of the introspection view (which is alongside the view host of the `UITextField`)
 - Get the next sibling containing `UITextField`

**Please note that this introspection method might break in future SwiftUI releases.** Future implementations might not use the same hierarchy, or might not use UIKit elements that are being looked for. Though the library is unlikely to crash, the `.introspect()` method will not be called in those cases.

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
NavigationView | UINavigationController | `.introspectNavigationController()` | **NavigationView child**
TabbedView | UITabBarController | `.introspectTabBarController()` | **TabbedView child**
TextField | UITextField | `.introspectTextField()` | TextField
Toggle | UISwitch | `.introspectSwitch()` | Toggle
Slider | UISlider | `.introspectSlider()` | Slider
Stepper | UIStepper | `.introspectStepper()` | Stepper
DatePicker | UIDatePicker | `.introspectDatePicker()` | DatePicker

**Missing an element?** Please [create an issue](https://github.com/timbersoftware/SwiftUI-Introspect/issues).

### Cannot implement

SwiftUI | Why
--- | ---
Text | Not a UILabel
Image | Not a UIImageView
SegmentedControl | Not a UISegmentedControl
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