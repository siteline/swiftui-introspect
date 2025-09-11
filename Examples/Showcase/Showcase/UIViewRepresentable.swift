import SwiftUI
import SwiftUIIntrospect

struct UIViewRepresentableShowcase: View {
    var body: some View {
        VStack(spacing: 10) {
            Text(".introspect(.view, ...)")
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .font(.system(.subheadline, design: .monospaced))
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .cyan
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.cyan.cgColor
                }
                #endif

            Button("A button", action: {})
                .padding(5)
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .yellow
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.yellow.cgColor
                }
                #endif

            Image(systemName: "scribble")
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(
                    .view,
                    on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
                ) { view in
                    view.backgroundColor = .blue
                }
                #elseif os(macOS)
                .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
                    view.layer?.backgroundColor = NSColor.blue.cgColor
                }
                #endif
        }
        .padding()
        #if os(iOS) || os(tvOS) || os(visionOS)
        .introspect(
            .view,
            on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
        ) { view in
            view.backgroundColor = .red
        }
        #elseif os(macOS)
        .introspect(.view, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { view in
            view.layer?.backgroundColor = NSColor.red.cgColor
        }
        #endif
    }
}
