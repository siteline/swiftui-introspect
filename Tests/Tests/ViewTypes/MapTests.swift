#if canImport(MapKit)
import MapKit
import SwiftUI
import SwiftUIIntrospect
import Testing

@MainActor
@Suite
struct MapTests {
	typealias PlatformMap = MKMapView

	@Test func introspect() async throws {
		let (entity1, entity2, entity3) = try await introspection(of: PlatformMap.self) { spy1, spy2, spy3 in
			let region = Binding.constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))

			VStack {
				Map(coordinateRegion: region)
					.introspect(
						.map,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .macOS(.v11, .v12, .v13, .v14, .v15, .v26), .visionOS(.v1, .v2, .v26),
						customize: spy1
					)

				Map(coordinateRegion: region)
					.introspect(
						.map,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .macOS(.v11, .v12, .v13, .v14, .v15, .v26), .visionOS(.v1, .v2, .v26),
						customize: spy2
					)

				Map(coordinateRegion: region)
					.introspect(
						.map,
						on: .iOS(.v14, .v15, .v16, .v17, .v18, .v26), .tvOS(.v14, .v15, .v16, .v17, .v18, .v26), .macOS(.v11, .v12, .v13, .v14, .v15, .v26), .visionOS(.v1, .v2, .v26),
						customize: spy3
					)
			}
		}
		#expect(entity1 !== entity2)
		#expect(entity1 !== entity3)
		#expect(entity2 !== entity3)
	}
}
#endif
