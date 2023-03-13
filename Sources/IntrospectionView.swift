//import SwiftUI
//
//struct IntrospectionView<Observed, Target>: PlatformViewRepresentable {
//    @Binding
//    var observed: Observed
//    let selector: (PlatformView) -> Target?
//    let customize: (Target, Observed) -> Void
//
//    #if canImport(UIKit)
//    func makeUIView(context: Context) -> IntrospectionPlatformView {
//        makePlatformView(context: context)
//    }
//    func updateUIView(_ view: IntrospectionPlatformView, context: Context) {
//        updatePlatformView(view, context: context)
//    }
//    static func dismantleUIView(_ view: IntrospectionPlatformView, coordinator: ()) {
//        dismantlePlatformView(view, coordinator: coordinator)
//    }
//    #elseif canImport(AppKit)
//    func makeNSView(context: Context) -> IntrospectionPlatformView {
//        makePlatformView(context: context)
//    }
//    func updateNSView(_ view: IntrospectionPlatformView, context: Context) {
//        updatePlatformView(view, context: context)
//    }
//    static func dismantleUIView(_ view: IntrospectionPlatformView, coordinator: ()) {
//        dismantlePlatformView(view, coordinator: coordinator)
//    }
//    #endif
//
//    // TODO: in Swift 5.8
//    // #if canImport(UIKit)
//    // @_implements(Self, makeUIView)
//    // #elseif canImport(AppKit)
//    // @_implements(Self, makeNSView)
//    // #endif
//    private func makePlatformView(context: Context) -> IntrospectionPlatformView {
//        let view = IntrospectionPlatformView()
//        view.handler = { [weak view] in
//            guard let view = view else { return }
//            guard let target = selector(view) else {
//                return
//            }
//            self.customize(target, observed)
//            view.handler = nil
//        }
//        return view
//    }
//
//    // TODO: in Swift 5.8
//    // #if canImport(UIKit)
//    // @_implements(Self, updateUIView)
//    // #elseif canImport(AppKit)
//    // @_implements(Self, updateNSView)
//    // #endif
//    private func updatePlatformView(_ view: IntrospectionPlatformView, context: Context) {
//        guard let target = selector(view) else {
//            return
//        }
//        self.customize(target, observed)
//    }
//    // TODO: in Swift 5.8
//    // #if canImport(UIKit)
//    // @_implements(Self, dismantleUIView)
//    // #elseif canImport(AppKit)
//    // @_implements(Self, dismantleNSView)
//    // #endif
//    private static func dismantlePlatformView(_ view: IntrospectionPlatformView, coordinator: ()) {
//        view.handler = nil
//    }
//}
//
//final class IntrospectionPlatformView: PlatformView {
//    var handler: (() -> Void)?
//
//    #if canImport(UIKit)
////    override func didMove(toParent parent: UIViewController?) {
////        super.didMove(toParent: parent)
////        handler?() // will always be called for controller targets
////    }
////
////    override func viewDidLayoutSubviews() {
////        super.viewDidLayoutSubviews()
////        handler?() // optimistic, will be called most times for view targets
////    }
////
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////        handler?() // backup for some views on iOS 14 which start as 0-sized (e.g. List)
////    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(self)
//        handler?()
//    }
//    #elseif canImport(AppKit)
//    // TODO: didMove(toParent:) is not an AppKit API. What to do?
//
////    override func loadView() {
////        view = NSView()
////    }
////
////    override func viewDidLayout() {
////        super.viewDidLayout()
////        handler?()
////    }
////
////    override func viewDidAppear() {
////        super.viewDidAppear()
////        handler?()
////    }
//    #endif
//}
