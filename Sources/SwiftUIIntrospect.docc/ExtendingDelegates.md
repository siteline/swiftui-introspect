# Extending Delegates

Customize an introspected view's delegate without discarding the one SwiftUI relies on.

## Overview

Many of the views SwiftUI creates already have a delegate when your customization closure runs, and SwiftUI relies on it to keep the view up to date. For example, the delegate of a `List`'s `UICollectionView` displays and updates the list's rows. Assigning your own delegate discards SwiftUI's, and the list then shows stale or reused rows when your data changes or when you scroll.

Instead of replacing the delegate, install one that implements only the methods you need and forwards every other call to the delegate it replaced. The methods you implement replace SwiftUI's, so call the same method on SwiftUI's delegate from each of them.

## Forward with DelegateProxy

[`DelegateProxy`](https://swiftpackageindex.com/davdroman/objc-runtime-tools/main/documentation/delegateforwarding/delegateproxy), from [ObjCRuntimeTools](https://github.com/davdroman/objc-runtime-tools), does this forwarding. Subclass it with the delegate protocol, implement the methods you need, and call through `forwardee`:

```swift
import DelegateForwarding
import SwiftUI
import SwiftUIIntrospect

final class ListDelegate: DelegateProxy<any UICollectionViewDelegate>, UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print(scrollView.contentOffset)
    forwardee?.scrollViewDidScroll?(scrollView)
  }
}

struct ContentView: View {
  @State private var listDelegate = ListDelegate()

  var body: some View {
    List {
      // ...
    }
    .introspect(.list, on: .iOS(.v16, .v17, .v18, .v26)) { collectionView in
      listDelegate.install(on: collectionView, at: \.delegate)
    }
  }
}
```

Installing again while the proxy holds the delegate does nothing, so it's safe to call each time the closure runs.

## Forward by Hand

Without the dependency, a delegate forwards the methods it doesn't implement by overriding `responds(to:)` and `forwardingTarget(for:)`. Set its `base` before assigning it, because UIKit asks a delegate which methods it implements when it's assigned:

```swift
final class ListDelegate: NSObject, UICollectionViewDelegate {
  weak var base: UICollectionViewDelegate?

  override func responds(to selector: Selector!) -> Bool {
    super.responds(to: selector) || base?.responds(to: selector) == true
  }

  override func forwardingTarget(for selector: Selector!) -> Any? {
    base
  }

  // Implement the methods you need, calling the same method on `base` from each.
}

struct ContentView: View {
  @State private var listDelegate = ListDelegate()

  var body: some View {
    List {
      // ...
    }
    .introspect(.list, on: .iOS(.v16, .v17, .v18, .v26)) { collectionView in
      guard collectionView.delegate !== listDelegate else { return }
      listDelegate.base = collectionView.delegate
      collectionView.delegate = listDelegate
    }
  }
}
```

## Prefer SwiftUI Modifiers

For scroll events alone, `onScrollGeometryChange(for:of:action:)` and `onScrollPhaseChange(_:)`, available from iOS 18, leave the delegate untouched.
