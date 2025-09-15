import SwiftUI
import SwiftUIIntrospect

struct AppView: View {
	var body: some View {
		ContentView()
			#if os(iOS) || os(tvOS) || os(visionOS)
			.introspect(
				.window,
				on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26), .visionOS(.v1, .v2, .v26)
			) { window in
				window.backgroundColor = .brown
			}
			#elseif os(macOS)
			.introspect(.window, on: .macOS(.v12, .v13, .v14, .v15, .v26)) { window in
				window.backgroundColor = .lightGray
			}
			#endif
	}
}

struct ContentView: View {
	@State var selection = 0

	var body: some View {
		TabView(selection: $selection) {
			ListShowcase()
				.tabItem { Label("List", systemImage: "1.circle") }
				.tag(0)
			ScrollViewShowcase()
				.tabItem { Label("ScrollView", systemImage: "2.circle") }
				.tag(1)
			#if !os(macOS)
			NavigationShowcase()
				.tabItem { Label("Navigation", systemImage: "3.circle") }
				.tag(2)
			PresentationShowcase()
				.tabItem { Label("Presentation", systemImage: "4.circle") }
				.tag(3)
			#endif
			ControlsShowcase()
				.tabItem { Label("Controls", systemImage: "5.circle") }
				.tag(4)
			UIViewRepresentableShowcase()
				.tabItem { Label("UIViewRepresentable", systemImage: "6.circle") }
				.tag(5)
		}
		#if os(iOS) || os(tvOS)
		.introspect(.tabView, on: .iOS(.v15, .v16, .v17, .v18, .v26), .tvOS(.v15, .v16, .v17, .v18, .v26)) { tabBarController in
			if #available(iOS 26, macOS 26, tvOS 26, *) {
				tabBarController.tabBar.backgroundColor = .green
			} else {
				let appearance = UITabBarAppearance()
				appearance.configureWithOpaqueBackground()
				appearance.backgroundColor = .green
				tabBarController.tabBar.standardAppearance = appearance
				tabBarController.tabBar.scrollEdgeAppearance = appearance
			}
		}
		#elseif os(macOS)
		.introspect(.tabView, on: .macOS(.v12, .v13, .v14)) { splitView in
			splitView.subviews.first?.layer?.backgroundColor = NSColor.green.cgColor
		}
		#endif
	}
}

#Preview {
	AppView()
}
