import SwiftUI
import SwiftUIIntrospect

struct ScrollViewShowcase: View {
    @State var firstScrollViewFound: Bool = false
    @State var secondScrollViewFound: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            ScrollView {
                Text("Default")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
            }

            ScrollView {
                Text(".introspect(.scrollView, ...)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
            }
            .background(Color(.cyan))
            #if os(iOS) || os(tvOS) || os(visionOS)
            .introspect(
                .scrollView,
                on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
            ) { scrollView in
                scrollView.layer.backgroundColor = UIColor.cyan.cgColor
                scrollView.layer.cornerRadius = 12
                scrollView.clipsToBounds = true
//                scrollView.flashScrollIndicators()
                scrollView.bounces = false
            }
//            .modifier {
//                if #available(iOS 16, tvOS 16, *) {
//                    $0.scroll
//                }
//            }
            #elseif os(macOS)
            .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { scrollView in
                scrollView.drawsBackground = true
                scrollView.backgroundColor = .cyan
            }
            #endif

            ScrollView {
                Text(".introspect(.scrollView, ..., scope: .ancestor)")
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                    #if os(iOS) || os(tvOS) || os(visionOS)
                    .introspect(
                        .scrollView,
                        on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26),
                        scope: .ancestor
                    ) { scrollView in
                        scrollView.layer.backgroundColor = UIColor.cyan.cgColor
                    }
                    #elseif os(macOS)
                    .introspect(.scrollView, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor) { scrollView in
                        scrollView.drawsBackground = true
                        scrollView.backgroundColor = .cyan
                    }
                    #endif
            }
        }
    }
}
