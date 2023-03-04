import SwiftUI

public typealias IntrospectionContainerID = UUID

// https://stackoverflow.com/a/71135581/1922543
struct Wrapper<Content: View>: View {
    let id: IntrospectionContainerID
    @State private var size: CGSize?
    @State private var outsideSize: CGSize?
    private let content: () -> Content

    init(
        id: IntrospectionContainerID,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.id = id
        self.content = content
    }

    var body: some View {
        GeometryReader { outside in
            Color.clear.preference(
                key: SizePreferenceKey.self,
                value: outside.size
            )
        }
        .onPreferenceChange(SizePreferenceKey.self) { newSize in
            outsideSize = newSize
        }
        .frame(width: size?.width, height: size?.height)
        .overlay( // or background?
            outsideSize != nil ?
                Representable(id: id) {
                    content()
                        .background(
                            GeometryReader { inside in
                                Color.clear.preference(
                                    key: SizePreferenceKey.self,
                                    value: inside.size
                                )
                            }
                            .onPreferenceChange(SizePreferenceKey.self) { newSize in
                                size = newSize
                            }
                        )
                        .frame(width: outsideSize!.width, height: outsideSize!.height)
                        .fixedSize()
                        .frame(width: size?.width ?? 0, height: size?.height ?? 0)
                }
                .frame(width: size?.width ?? 0, height: size?.height ?? 0)
            : nil
        )
    }
}

struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct Representable<Content: View>: UIViewRepresentable {
    let id: IntrospectionContainerID
    private let content: () -> Content

    init(
        id: IntrospectionContainerID,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.id = id
        self.content = content
    }

    func makeUIView(context: Context) -> UIView {
        let host = UIHostingController(rootView: content())
        let hostView = host.view!
        hostView.accessibilityIdentifier = id.uuidString
        return hostView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.backgroundColor = .systemRed
    }
}

//final class UIHostingController_FB9641883<Content: View>: UIHostingController<Content> {
//    private var heightConstraint: NSLayoutConstraint?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if #available(iOS 15.0, *) {
//            heightConstraint = view.heightAnchor.constraint(equalToConstant: view.intrinsicContentSize.height)
//            NSLayoutConstraint.activate([
//                heightConstraint!,
//            ])
//        }
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        preferredContentSize = view.intrinsicContentSize
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        heightConstraint?.constant = view.intrinsicContentSize.height
//    }
//}

//struct IntrospectionUIContainerView<Content: View>: UIViewRepresentable {
//    let id: IntrospectionContainerID
//    @ViewBuilder
//    let content: Content
//
//    func makeUIView(context: Context) -> some UIView {
//        let host = UIHostingController(rootView: content)
////        if #available(iOS 16, *) {
////            host.sizingOptions = .intrinsicContentSize
////        }
//        let hostView = host.view!
//        hostView.accessibilityIdentifier = id.uuidString
//        hostView.backgroundColor = .blue
//        return hostView
//    }
//
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//
//    }
//}
