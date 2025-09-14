import SwiftUI
import SwiftUIIntrospect

struct NavigationShowcase: View {
	var body: some View {
		NavigationView {
			Text("Content")
				.searchable(text: .constant(""))
				#if os(iOS) || os(visionOS)
				.navigationBarTitle(Text("Customized"), displayMode: .inline)
				#elseif os(macOS)
				.navigationTitle(Text("Navigation"))
				#endif
		}
		#if os(iOS) || os(tvOS) || os(visionOS)
		.introspect(
			.navigationView(style: .stack),
			on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
		) { navigationController in
			navigationController.navigationBar.backgroundColor = .cyan
		}
		.introspect(
			.navigationView(style: .columns),
			on: .iOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
		) { splitViewController in
			#if os(visionOS)
			splitViewController.preferredDisplayMode = .oneBesideSecondary
			#else
			splitViewController.preferredDisplayMode = .oneOverSecondary
			#endif
		}
		.introspect(.navigationView(style: .columns), on: .tvOS(.v15, .v16, .v17, .v18, .v26)) { navigationController in
			navigationController.navigationBar.backgroundColor = .cyan
		}
		.introspect(
			.searchField,
			on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
		) { searchBar in
			searchBar.backgroundColor = .red
			#if os(iOS)
			searchBar.searchTextField.backgroundColor = .purple
			#endif
		}
		#endif
	}
}
