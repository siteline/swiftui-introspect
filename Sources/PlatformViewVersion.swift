import SwiftUI

public struct PlatformViewVersionPredicate<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    let matches: Bool
    let selector: IntrospectionSelector<PlatformSpecificEntity>?
    
    private init<Version: PlatformVersion>(
        _ versions: [PlatformViewVersion<Version, SwiftUIViewType, PlatformSpecificEntity>],
        matcher: (PlatformViewVersion<Version, SwiftUIViewType, PlatformSpecificEntity>) -> Bool
    ) {
        if let currentVersion = versions.first(where: matcher) {
            self.matches = true
            self.selector = currentVersion.selector
        } else {
            self.matches = false
            self.selector = nil
        }
    }
    
    public static func iOS(_ versions: (iOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions, matcher: \.isCurrent)
    }
    
    @_spi(Advanced)
    public static func iOS(_ versions: PartialRangeFrom<iOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>>) -> Self {
        Self([versions.lowerBound], matcher: \.isCurrentOrPast)
    }
    
    public static func tvOS(_ versions: (tvOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions, matcher: \.isCurrent)
    }

    @_spi(Advanced)
    public static func tvOS(_ versions: PartialRangeFrom<tvOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>>) -> Self {
        Self([versions.lowerBound], matcher: \.isCurrentOrPast)
    }

    public static func macOS(_ versions: (macOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions, matcher: \.isCurrent)
    }

    @_spi(Advanced)
    public static func macOS(_ versions: PartialRangeFrom<macOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>>) -> Self {
        Self([versions.lowerBound], matcher: \.isCurrentOrPast)
    }
}

public typealias iOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<iOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias tvOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<tvOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias macOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<macOSVersion, SwiftUIViewType, PlatformSpecificEntity>

public enum PlatformViewVersion<Version: PlatformVersion, SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    @_spi(Private) case available(Version, IntrospectionSelector<PlatformSpecificEntity>?)
    @_spi(Private) case unavailable

    var isCurrent: Bool {
        switch self {
        case .available(let version, _):
            return version.isCurrent
        case .unavailable:
            return false
        }
    }

    var isCurrentOrPast: Bool {
        switch self {
        case .available(let version, _):
            return version.isCurrentOrPast
        case .unavailable:
            return false
        }
    }

    var selector: IntrospectionSelector<PlatformSpecificEntity>? {
        switch self {
        case .available(_, let selector):
            return selector
        case .unavailable:
            return nil
        }
    }
}

extension PlatformViewVersion {
    @_spi(Internals) public init(for version: Version, selector: IntrospectionSelector<PlatformSpecificEntity>? = nil) {
        self = .available(version, selector)
    }

    @_spi(Internals) public static func unavailable(file: StaticString = #file, line: UInt = #line) -> Self {
        let filePath = file.withUTF8Buffer { String(decoding: $0, as: UTF8.self) }
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        runtimeWarn(
            """
            If you're seeing this, someone forgot to mark \(fileName):\(line) as unavailable.

            This won't have any effect, but it should be disallowed altogether.

            Please report it upstream so we can properly fix it by using the following link:

            https://github.com/siteline/swiftui-introspect/issues/new?title=`\(fileName):\(line)`+should+be+marked+unavailable
            """
        )
        return .unavailable
    }
}

// This conformance isn't meant to be used directly by the user,
// it's only to satisfy requirements for forming ranges (e.g. `.v15...`).
extension PlatformViewVersion: Comparable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
