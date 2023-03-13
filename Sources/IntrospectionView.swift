import SwiftUI

final class IntrospectionUIViewController: UIViewController {
    var handler: (() -> Void)?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        handler?() // optimistic, will be called most times
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handler?() // backup for some views on iOS 14 which start as 0-sized (e.g. List)
    }
}

struct IntrospectionView<Observed, Target: PlatformView>: UIViewControllerRepresentable {
    @Binding
    var observed: Observed
    let selector: (UIView) -> Target?
    let customize: (Target, Observed) -> Void

    func makeUIViewController(context: Context) -> IntrospectionUIViewController {
        let controller = IntrospectionUIViewController()
        controller.handler = { [weak controller] in
            guard let controller = controller else { return }
            guard let target = selector(controller.view) else {
                return
            }
            self.customize(target, observed)
            controller.handler = nil
        }
        return controller
    }

    func updateUIViewController(_ controller: IntrospectionUIViewController, context: Context) {
        guard let target = selector(controller.view) else {
            return
        }
        self.customize(target, observed)
    }

    static func dismantleUIViewController(_ controller: IntrospectionUIViewController, coordinator: ()) {
        controller.handler = nil
    }
}
