import SwiftUI
import Testing

#if canImport(UIKit)
@MainActor
enum TestUtils {
	#if targetEnvironment(macCatalyst) || os(visionOS)
	static let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 480, height: 300))
	#else
	static let window = UIWindow(frame: UIScreen.main.bounds)
	#endif

	static func present(view: some View, file: StaticString = #file, line: UInt = #line) {
		if
			let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.first
			??
			UIApplication.shared.windows.first
		{
			window.rootViewController = UIHostingController(rootView: view)
		} else {
			window.rootViewController = UIHostingController(rootView: view)
			window.makeKeyAndVisible()
			window.layoutIfNeeded()
		}
	}
}
#elseif canImport(AppKit)
@MainActor
enum TestUtils {
	private static let window = NSWindow(
		contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		backing: .buffered,
		defer: true
	)

	static func present(view: some View) {
		window.contentView = NSHostingView(rootView: view)
		window.makeKeyAndOrderFront(nil)
		window.layoutIfNeeded()
	}
}
#endif

@MainActor
@discardableResult
func introspection<Entity: AnyObject & Sendable>(
	of type: Entity.Type,
	timeout: TimeInterval = 3,
	sourceLocation: SourceLocation = #_sourceLocation,
	@ViewBuilder view: (
		_ spy1: @escaping (Entity) -> Void
	) -> some View
) async throws -> Entity {
	var entity1: Entity?
	return try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation1 in
		let view = view(
			{
				confirmation1()
				entity1 = $0
			}
		)

		TestUtils.present(view: view)

		let startInstant = Date()
		while
			Date().timeIntervalSince(startInstant) < timeout,
			entity1 == nil
		{
			await Task.yield()
		}

		return try #require(entity1, sourceLocation: sourceLocation)
	}
}

@MainActor
@discardableResult
func introspection<Entity: AnyObject & Sendable>(
	of type: Entity.Type,
	timeout: TimeInterval = 3,
	sourceLocation: SourceLocation = #_sourceLocation,
	@ViewBuilder view: (
		_ spy1: @escaping (Entity) -> Void,
		_ spy2: @escaping (Entity) -> Void
	) -> some View
) async throws -> (Entity, Entity) {
	var entity1: Entity?
	var entity2: Entity?
	return try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation1 in
		try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation2 in
			let view = view(
				{
					confirmation1()
					entity1 = $0
				},
				{
					confirmation2()
					entity2 = $0
				}
			)

			TestUtils.present(view: view)

			let startInstant = Date()
			while
				Date().timeIntervalSince(startInstant) < timeout,
				entity1 == nil ||
				entity2 == nil
			{
				await Task.yield()
			}

			return try (
				#require(entity1, sourceLocation: sourceLocation),
				#require(entity2, sourceLocation: sourceLocation)
			)
		}
	}
}

@MainActor
@discardableResult
func introspection<Entity: AnyObject & Sendable>(
	of type: Entity.Type,
	timeout: TimeInterval = 3,
	sourceLocation: SourceLocation = #_sourceLocation,
	@ViewBuilder view: (
		_ spy1: @escaping (Entity) -> Void,
		_ spy2: @escaping (Entity) -> Void,
		_ spy3: @escaping (Entity) -> Void
	) -> some View
) async throws -> (Entity, Entity, Entity) {
	var entity1: Entity?
	var entity2: Entity?
	var entity3: Entity?
	return try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation1 in
		try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation2 in
			try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation3 in
				let view = view(
					{
						confirmation1()
						entity1 = $0
					},
					{
						confirmation2()
						entity2 = $0
					},
					{
						confirmation3()
						entity3 = $0
					}
				)

				TestUtils.present(view: view)

				let startInstant = Date()
				while
					Date().timeIntervalSince(startInstant) < timeout,
					entity1 == nil ||
					entity2 == nil ||
					entity3 == nil
				{
					await Task.yield()
				}

				return try (
					#require(entity1, sourceLocation: sourceLocation),
					#require(entity2, sourceLocation: sourceLocation),
					#require(entity3, sourceLocation: sourceLocation)
				)
			}
		}
	}
}

@MainActor
@discardableResult
func introspection<Entity: AnyObject & Sendable>(
	of type: Entity.Type,
	timeout: TimeInterval = 3,
	sourceLocation: SourceLocation = #_sourceLocation,
	@ViewBuilder view: (
		_ spy1: @escaping (Entity) -> Void,
		_ spy2: @escaping (Entity) -> Void,
		_ spy3: @escaping (Entity) -> Void,
		_ spy4: @escaping (Entity) -> Void
	) -> some View
) async throws -> (Entity, Entity, Entity, Entity) {
	var entity1: Entity?
	var entity2: Entity?
	var entity3: Entity?
	var entity4: Entity?
	return try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation1 in
		try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation2 in
			try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation3 in
				try await confirmation(expectedCount: 1..., sourceLocation: sourceLocation) { confirmation4 in
					let view = view(
						{
							confirmation1()
							entity1 = $0
						},
						{
							confirmation2()
							entity2 = $0
						},
						{
							confirmation3()
							entity3 = $0
						},
						{
							confirmation4()
							entity4 = $0
						}
					)

					TestUtils.present(view: view)

					let startInstant = Date()
					while
						Date().timeIntervalSince(startInstant) < timeout,
						entity1 == nil ||
						entity2 == nil ||
						entity3 == nil ||
						entity4 == nil
					{
						await Task.yield()
					}

					return try (
						#require(entity1, sourceLocation: sourceLocation),
						#require(entity2, sourceLocation: sourceLocation),
						#require(entity3, sourceLocation: sourceLocation),
						#require(entity4, sourceLocation: sourceLocation)
					)
				}
			}
		}
	}
}
