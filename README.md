Introspect for SwiftUI
======================

Introspect allows you to get the underlying UIKit element of a SwiftUI view.

### Implemented

SwiftUI | UIKit | Introspect
--- | --- | ---
List | UITableView | `.introspectTableView()` on a list child
ScrollView | UIScrollView | `.introspectScrollView()` on a scroll view child
NavigationView | UINavigationController | `.introspectNavigationController()` on a navigation child
TextField | UITextField | `.introspectTextField()`
Toggle | UISwitch | `.introspectSwitch()`
Slider | UISlider | `.introspectSlider()`
Stepper | UIStepper | `.introspectStepper()`
DatePicker | UIDatePicker | `.introspectDatePicker()`


### Not implemented

SwiftUI | UIKit
--- | ---
TabbedView | UITabBarController

### Cannot implement

SwiftUI | Why
--- | ---
Text | Not a UILabel
Image | Not a UIImageView
SegmentedControl | Not a UISegmentedControl
Button | Not a UIButton