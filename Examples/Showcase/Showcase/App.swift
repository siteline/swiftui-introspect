import SwiftUI

@main
struct App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

import Introspect

struct MainView: View {
    enum ViewTab {
        case home
        case search
    }

    @State private var selectedTab: ViewTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            InternalView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(ViewTab.home)
            InternalView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(ViewTab.search)
        }
    }
}

struct InternalView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(1..<100) { num in
                    Text(String(num))
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarTitle("Search", displayMode: .large)
            .customScopeBar()
        }
    }
}

extension View {
    func customScopeBar() -> some View {
        self.modifier(CustomScopeBarModifier())
    }
}

struct CustomScopeBarModifier: ViewModifier {
    @State private var hostingController: UIViewController?

    func body(content: Content) -> some View {
        content
            .introspectSearchController { searchController in
                // if we've already set up the hosting controller before, don't do this at all
                guard hostingController == nil else { return }

                searchController.hidesNavigationBarDuringPresentation = true
                searchController.searchBar.showsScopeBar = true
                searchController.searchBar.scopeButtonTitles = [""]

                (searchController.searchBar.value(forKey: "_scopeBar") as? UIView)?.isHidden = true

                let hostingController = UIHostingController(rootView: FilterView())
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                hostingController.view.backgroundColor = .clear

                guard let containerView = searchController.searchBar.value(forKey: "_scopeBarContainerView") as? UIView else {
                    return
                }
                searchController.navigationItem.hidesSearchBarWhenScrolling = false
                containerView.addSubview(hostingController.view)

                NSLayoutConstraint.activate([
                    hostingController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor),
                    hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    hostingController.view.heightAnchor.constraint(equalTo: containerView.heightAnchor)
                ])

                // saves the hosting controller's reference weakly for the check at the top
                self.hostingController = hostingController
            }
            .introspectNavigationController { navigationController in
                navigationController.navigationBar.prefersLargeTitles = true
                navigationController.navigationBar.sizeToFit()
            }
    }
}

struct FilterView: View {
    @State private var textName = "first"
    @State private var secondTextName = "First"
    var body: some View {
        Picker("", selection: $textName) {
            Text("First").tag("first")
            Text("Second").tag("second")
        }
        .pickerStyle(.segmented)
    }
}
