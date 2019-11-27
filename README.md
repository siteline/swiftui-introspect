Introspect for SwiftUI
======================

Introspect allows you to get the underlying UIKit element of a SwiftUI view.

### Implemented

SwiftUI | UIKit | Introspect
--- | --- | ---
List | UITableView | `.introspectTableView()` on a list child
NavigationView | UINavigationController | `.introspectNavigationController()` on a navigation child
TextField | UITextField | `.introspectTextField()`


### Not implemented

SwiftUI | UIKit
--- | ---
Toggle | UISwitch
Slider | UISlider
Button | UIButton
ScrollView | UIScrollView
TabbedView | UITabBarController
Stepper | UIStepper
DatePicker | UIDatePicker

### Cannot implement

SwiftUI | Why
--- | ---
Text | Not a UILabel
Image | Not a UIImageView
SegmentedControl | Not a UISegmentedControl