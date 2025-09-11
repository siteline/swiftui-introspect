import SwiftUI
import SwiftUIIntrospect

struct ListShowcase: View {
    @State var receiverListFound: Bool = false
    @State var ancestorListFound: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Default")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
            }

            VStack {
                Text(".introspect(.list, ...)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
                .modifier { list in
                    if #available(iOS 16, *) {
                        list.background {
                                if receiverListFound {
                                    Color(uiColor: .cyan)
                                }
                            }
                            .scrollContentBackground(.hidden)
                    } else {
                        list
                    }
                }
                #if os(iOS) || os(tvOS) || os(visionOS)
                .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { tableView in
                    tableView.backgroundView = UIView()
                    tableView.backgroundColor = .cyan
                }
                .introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)) { collectionView in
                    DispatchQueue.main.async {
                        receiverListFound = true
                    }
                }
                #elseif os(macOS)
                .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26)) { tableView in
                    DispatchQueue.main.async {
                        receiverListFound = true
                    }
                }
                #endif
            }

            VStack {
                Text(".introspect(.list, ..., scope: .ancestor)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 12)
                    .font(.system(.subheadline, design: .monospaced))
                List {
                    Text("Item 1")
                    Text("Item 2")
                        #if os(iOS) || os(tvOS) || os(visionOS)
                        .introspect(.list, on: .iOS(.v13, .v14, .v15), .tvOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26), scope: .ancestor) { tableView in
                            tableView.backgroundView = UIView()
                            tableView.backgroundColor = .cyan
                        }
                        .introspect(.list, on: .iOS(.v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26), scope: .ancestor) { collectionView in
                            DispatchQueue.main.async {
                                ancestorListFound = true
                            }
                        }
                        #elseif os(macOS)
                        .introspect(.list, on: .macOS(.v10_15, .v11, .v12, .v13, .v14, .v15, .v26), scope: .ancestor) { tableView in
                            DispatchQueue.main.async {
                                ancestorListFound = true
                            }
                        }
                        #endif
                }
                .modifier { list in
                    if #available(iOS 16, *) {
                        list.background {
                            if ancestorListFound {
                                Color(uiColor: .cyan)
                            }
                        }
                        .scrollContentBackground(.hidden)
                    } else {
                        list
                    }
                }
            }
        }

    }
}
