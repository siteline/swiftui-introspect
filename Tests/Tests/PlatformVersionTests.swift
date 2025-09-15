@_spi(Internals) import SwiftUIIntrospect
import Testing

@Suite
struct PlatformVersionTests {
	@Test func iOS_isCurrent() {
		#if os(iOS)
		if #available(iOS 26, *) {
			#expect(iOSVersion.v26.isCurrent == true)
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 18, *) {
			#expect(iOSVersion.v18.isCurrent == true)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 17, *) {
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == true)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 16, *) {
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == true)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 15, *) {
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == true)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 14, *) {
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == true)
			#expect(iOSVersion.v13.isCurrent == false)
		} else if #available(iOS 13, *) {
			#expect(iOSVersion.v18.isCurrent == false)
			#expect(iOSVersion.v17.isCurrent == false)
			#expect(iOSVersion.v16.isCurrent == false)
			#expect(iOSVersion.v15.isCurrent == false)
			#expect(iOSVersion.v14.isCurrent == false)
			#expect(iOSVersion.v13.isCurrent == true)
		}
		#else
		#expect(iOSVersion.v26.isCurrent == false)
		#expect(iOSVersion.v18.isCurrent == false)
		#expect(iOSVersion.v17.isCurrent == false)
		#expect(iOSVersion.v16.isCurrent == false)
		#expect(iOSVersion.v15.isCurrent == false)
		#expect(iOSVersion.v14.isCurrent == false)
		#expect(iOSVersion.v13.isCurrent == false)
		#endif
	}

	@Test func iOS_isCurrentOrPast() {
		#if os(iOS)
		if #available(iOS 26, *) {
			#expect(iOSVersion.v26.isCurrentOrPast == true)
			#expect(iOSVersion.v18.isCurrentOrPast == true)
			#expect(iOSVersion.v17.isCurrentOrPast == true)
			#expect(iOSVersion.v16.isCurrentOrPast == true)
			#expect(iOSVersion.v15.isCurrentOrPast == true)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 18, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == true)
			#expect(iOSVersion.v17.isCurrentOrPast == true)
			#expect(iOSVersion.v16.isCurrentOrPast == true)
			#expect(iOSVersion.v15.isCurrentOrPast == true)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 17, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == false)
			#expect(iOSVersion.v17.isCurrentOrPast == true)
			#expect(iOSVersion.v16.isCurrentOrPast == true)
			#expect(iOSVersion.v15.isCurrentOrPast == true)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 16, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == false)
			#expect(iOSVersion.v17.isCurrentOrPast == false)
			#expect(iOSVersion.v16.isCurrentOrPast == true)
			#expect(iOSVersion.v15.isCurrentOrPast == true)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 15, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == false)
			#expect(iOSVersion.v17.isCurrentOrPast == false)
			#expect(iOSVersion.v16.isCurrentOrPast == false)
			#expect(iOSVersion.v15.isCurrentOrPast == true)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 14, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == false)
			#expect(iOSVersion.v17.isCurrentOrPast == false)
			#expect(iOSVersion.v16.isCurrentOrPast == false)
			#expect(iOSVersion.v15.isCurrentOrPast == false)
			#expect(iOSVersion.v14.isCurrentOrPast == true)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		} else if #available(iOS 13, *) {
			#expect(iOSVersion.v18.isCurrentOrPast == false)
			#expect(iOSVersion.v17.isCurrentOrPast == false)
			#expect(iOSVersion.v16.isCurrentOrPast == false)
			#expect(iOSVersion.v15.isCurrentOrPast == false)
			#expect(iOSVersion.v14.isCurrentOrPast == false)
			#expect(iOSVersion.v13.isCurrentOrPast == true)
		}
		#else
		#expect(iOSVersion.v26.isCurrentOrPast == false)
		#expect(iOSVersion.v18.isCurrentOrPast == false)
		#expect(iOSVersion.v17.isCurrentOrPast == false)
		#expect(iOSVersion.v16.isCurrentOrPast == false)
		#expect(iOSVersion.v15.isCurrentOrPast == false)
		#expect(iOSVersion.v14.isCurrentOrPast == false)
		#expect(iOSVersion.v13.isCurrentOrPast == false)
		#endif
	}

	@Test func macOS_isCurrent() {
		#if os(macOS)
		if #available(macOS 26, *) {
			#expect(macOSVersion.v26.isCurrent == true)
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 15, *) {
			#expect(macOSVersion.v15.isCurrent == true)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 14, *) {
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == true)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 13, *) {
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == true)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 12, *) {
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == true)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 11, *) {
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == true)
			#expect(macOSVersion.v10_15.isCurrent == false)
		} else if #available(macOS 10.15, *) {
			#expect(macOSVersion.v15.isCurrent == false)
			#expect(macOSVersion.v14.isCurrent == false)
			#expect(macOSVersion.v13.isCurrent == false)
			#expect(macOSVersion.v12.isCurrent == false)
			#expect(macOSVersion.v11.isCurrent == false)
			#expect(macOSVersion.v10_15.isCurrent == true)
		}
		#else
		#expect(macOSVersion.v26.isCurrent == false)
		#expect(macOSVersion.v15.isCurrent == false)
		#expect(macOSVersion.v14.isCurrent == false)
		#expect(macOSVersion.v13.isCurrent == false)
		#expect(macOSVersion.v12.isCurrent == false)
		#expect(macOSVersion.v11.isCurrent == false)
		#expect(macOSVersion.v10_15.isCurrent == false)
		#endif
	}

	@Test func macOS_isCurrentOrPast() {
		#if os(macOS)
		if #available(macOS 26, *) {
			#expect(macOSVersion.v26.isCurrentOrPast == true)
			#expect(macOSVersion.v15.isCurrentOrPast == true)
			#expect(macOSVersion.v14.isCurrentOrPast == true)
			#expect(macOSVersion.v13.isCurrentOrPast == true)
			#expect(macOSVersion.v12.isCurrentOrPast == true)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 15, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == true)
			#expect(macOSVersion.v14.isCurrentOrPast == true)
			#expect(macOSVersion.v13.isCurrentOrPast == true)
			#expect(macOSVersion.v12.isCurrentOrPast == true)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 14, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == false)
			#expect(macOSVersion.v14.isCurrentOrPast == true)
			#expect(macOSVersion.v13.isCurrentOrPast == true)
			#expect(macOSVersion.v12.isCurrentOrPast == true)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 13, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == false)
			#expect(macOSVersion.v14.isCurrentOrPast == false)
			#expect(macOSVersion.v13.isCurrentOrPast == true)
			#expect(macOSVersion.v12.isCurrentOrPast == true)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 12, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == false)
			#expect(macOSVersion.v14.isCurrentOrPast == false)
			#expect(macOSVersion.v13.isCurrentOrPast == false)
			#expect(macOSVersion.v12.isCurrentOrPast == true)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 11, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == false)
			#expect(macOSVersion.v14.isCurrentOrPast == false)
			#expect(macOSVersion.v13.isCurrentOrPast == false)
			#expect(macOSVersion.v12.isCurrentOrPast == false)
			#expect(macOSVersion.v11.isCurrentOrPast == true)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		} else if #available(macOS 10.15, *) {
			#expect(macOSVersion.v15.isCurrentOrPast == false)
			#expect(macOSVersion.v14.isCurrentOrPast == false)
			#expect(macOSVersion.v13.isCurrentOrPast == false)
			#expect(macOSVersion.v12.isCurrentOrPast == false)
			#expect(macOSVersion.v11.isCurrentOrPast == false)
			#expect(macOSVersion.v10_15.isCurrentOrPast == true)
		}
		#else
		#expect(macOSVersion.v26.isCurrentOrPast == false)
		#expect(macOSVersion.v15.isCurrentOrPast == false)
		#expect(macOSVersion.v14.isCurrentOrPast == false)
		#expect(macOSVersion.v13.isCurrentOrPast == false)
		#expect(macOSVersion.v12.isCurrentOrPast == false)
		#expect(macOSVersion.v11.isCurrentOrPast == false)
		#expect(macOSVersion.v10_15.isCurrentOrPast == false)
		#endif
	}

	@Test func tvOS_isCurrent() {
		#if os(tvOS)
		if #available(tvOS 26, *) {
			#expect(tvOSVersion.v26.isCurrent == true)
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 18, *) {
			#expect(tvOSVersion.v18.isCurrent == true)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 17, *) {
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == true)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 16, *) {
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == true)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 15, *) {
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == true)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 14, *) {
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == true)
			#expect(tvOSVersion.v13.isCurrent == false)
		} else if #available(tvOS 13, *) {
			#expect(tvOSVersion.v18.isCurrent == false)
			#expect(tvOSVersion.v17.isCurrent == false)
			#expect(tvOSVersion.v16.isCurrent == false)
			#expect(tvOSVersion.v15.isCurrent == false)
			#expect(tvOSVersion.v14.isCurrent == false)
			#expect(tvOSVersion.v13.isCurrent == true)
		}
		#else
		#expect(tvOSVersion.v26.isCurrent == false)
		#expect(tvOSVersion.v18.isCurrent == false)
		#expect(tvOSVersion.v17.isCurrent == false)
		#expect(tvOSVersion.v16.isCurrent == false)
		#expect(tvOSVersion.v15.isCurrent == false)
		#expect(tvOSVersion.v14.isCurrent == false)
		#expect(tvOSVersion.v13.isCurrent == false)
		#endif
	}

	@Test func tvOS_isCurrentOrPast() {
		#if os(tvOS)
		if #available(tvOS 26, *) {
			#expect(tvOSVersion.v26.isCurrentOrPast == true)
			#expect(tvOSVersion.v18.isCurrentOrPast == true)
			#expect(tvOSVersion.v17.isCurrentOrPast == true)
			#expect(tvOSVersion.v16.isCurrentOrPast == true)
			#expect(tvOSVersion.v15.isCurrentOrPast == true)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 18, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == true)
			#expect(tvOSVersion.v17.isCurrentOrPast == true)
			#expect(tvOSVersion.v16.isCurrentOrPast == true)
			#expect(tvOSVersion.v15.isCurrentOrPast == true)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 17, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == false)
			#expect(tvOSVersion.v17.isCurrentOrPast == true)
			#expect(tvOSVersion.v16.isCurrentOrPast == true)
			#expect(tvOSVersion.v15.isCurrentOrPast == true)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 16, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == false)
			#expect(tvOSVersion.v17.isCurrentOrPast == false)
			#expect(tvOSVersion.v16.isCurrentOrPast == true)
			#expect(tvOSVersion.v15.isCurrentOrPast == true)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 15, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == false)
			#expect(tvOSVersion.v17.isCurrentOrPast == false)
			#expect(tvOSVersion.v16.isCurrentOrPast == false)
			#expect(tvOSVersion.v15.isCurrentOrPast == true)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 14, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == false)
			#expect(tvOSVersion.v17.isCurrentOrPast == false)
			#expect(tvOSVersion.v16.isCurrentOrPast == false)
			#expect(tvOSVersion.v15.isCurrentOrPast == false)
			#expect(tvOSVersion.v14.isCurrentOrPast == true)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		} else if #available(tvOS 13, *) {
			#expect(tvOSVersion.v18.isCurrentOrPast == false)
			#expect(tvOSVersion.v17.isCurrentOrPast == false)
			#expect(tvOSVersion.v16.isCurrentOrPast == false)
			#expect(tvOSVersion.v15.isCurrentOrPast == false)
			#expect(tvOSVersion.v14.isCurrentOrPast == false)
			#expect(tvOSVersion.v13.isCurrentOrPast == true)
		}
		#else
		#expect(tvOSVersion.v26.isCurrentOrPast == false)
		#expect(tvOSVersion.v18.isCurrentOrPast == false)
		#expect(tvOSVersion.v17.isCurrentOrPast == false)
		#expect(tvOSVersion.v16.isCurrentOrPast == false)
		#expect(tvOSVersion.v15.isCurrentOrPast == false)
		#expect(tvOSVersion.v14.isCurrentOrPast == false)
		#expect(tvOSVersion.v13.isCurrentOrPast == false)
		#endif
	}

	@Test func visionOS_isCurrent() {
		#if os(visionOS)
		if #available(visionOS 26, *) {
			#expect(visionOSVersion.v26.isCurrent == true)
			#expect(visionOSVersion.v2.isCurrent == false)
			#expect(visionOSVersion.v1.isCurrent == false)
		} else if #available(visionOS 2, *) {
			#expect(visionOSVersion.v26.isCurrent == false)
			#expect(visionOSVersion.v2.isCurrent == true)
			#expect(visionOSVersion.v1.isCurrent == false)
		} else if #available(visionOS 1, *) {
			#expect(visionOSVersion.v26.isCurrent == false)
			#expect(visionOSVersion.v2.isCurrent == false)
			#expect(visionOSVersion.v1.isCurrent == true)
		}
		#else
		#expect(visionOSVersion.v26.isCurrent == false)
		#expect(visionOSVersion.v2.isCurrent == false)
		#expect(visionOSVersion.v1.isCurrent == false)
		#endif
	}

	@Test func visionOS_isCurrentOrPast() {
		#if os(visionOS)
		if #available(visionOS 26, *) {
			#expect(visionOSVersion.v26.isCurrentOrPast == true)
			#expect(visionOSVersion.v2.isCurrentOrPast == true)
			#expect(visionOSVersion.v1.isCurrentOrPast == true)
		} else if #available(visionOS 2, *) {
			#expect(visionOSVersion.v26.isCurrentOrPast == false)
			#expect(visionOSVersion.v2.isCurrentOrPast == true)
			#expect(visionOSVersion.v1.isCurrentOrPast == true)
		} else if #available(visionOS 1, *) {
			#expect(visionOSVersion.v26.isCurrentOrPast == false)
			#expect(visionOSVersion.v2.isCurrentOrPast == false)
			#expect(visionOSVersion.v1.isCurrentOrPast == true)
		}
		#else
		#expect(visionOSVersion.v26.isCurrentOrPast == false)
		#expect(visionOSVersion.v2.isCurrentOrPast == false)
		#expect(visionOSVersion.v1.isCurrentOrPast == false)
		#endif
	}
}
