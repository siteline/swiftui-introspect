Introspect for SwiftUI
======================

Introspect allows you to get the underlying UIKit element of a SwiftUI view.

### Implemented

SwiftUI | UIKit | Introspect | Target
--- | --- | --- | ---
List | UITableView | `.introspectTableView()` | List, or List child
ScrollView | UIScrollView | `.introspectScrollView()` | ScrollView, or ScrollView child
NavigationView | UINavigationController | `.introspectNavigationController()` | NavigationView child
TabbedView | UITabBarController | `.introspectTabBarController()` | TabbedView child
TextField | UITextField | `.introspectTextField()` | TextField
Toggle | UISwitch | `.introspectSwitch()` | Toggle
Slider | UISlider | `.introspectSlider()` | Slider
Stepper | UIStepper | `.introspectStepper()` | Stepper
DatePicker | UIDatePicker | `.introspectDatePicker()` | DatePicker

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

```
List {
    Text("Item 1")
    Text("Item 2")
}
.introspectTableView { tableView in
    tableView.separatorStyle = .none
}
```

### ScrollView

```
ScrollView {
    Text("Item 2")
}
.introspectScrollView { scrollView in
    scrollView.refreshControl = UIRefreshControl()
}
```

### NavigationView

```
NavigationView {
    Text("Item 2")
    .introspectNavigationController { navigationController in
        navigationController.navigationBar.backgroundColor = .red
    }
}
```

### TextField

```
TextField("Text Field", text: $textFieldValue)
.introspectTextField { textField in
    textField.layer.backgroundColor = UIColor.red.cgColor
}
```