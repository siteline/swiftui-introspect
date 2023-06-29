import SwiftUI

public struct PlatformViewVersionGroup<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    let containsCurrent: Bool
    let selector: IntrospectionSelector<PlatformSpecificEntity>?

    private init<Version: PlatformVersion>(
        _ versions: [PlatformViewVersion<Version, SwiftUIViewType, PlatformSpecificEntity>]
    ) {
        if let currentVersion = versions.first(where: \.isCurrent) {
            self.containsCurrent = true
            self.selector = currentVersion.selector
        } else {
            self.containsCurrent = false
            self.selector = nil
        }
    }

    public static func iOS(_ versions: (iOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions)
    }

    public static func tvOS(_ versions: (tvOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions)
    }

    public static func macOS(_ versions: (macOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>)...) -> Self {
        Self(versions)
    }
}

@_spi(Advanced)
public struct PlatformViewVersionSingle<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    let isCurrentOrPast: Bool
    let selector: IntrospectionSelector<PlatformSpecificEntity>?

    private init<Version: PlatformVersion>(
        _ version: PlatformViewVersion<Version, SwiftUIViewType, PlatformSpecificEntity>
    ) {
        if version.isCurrentOrPast {
            self.isCurrentOrPast = true
            self.selector = version.selector
        } else {
            self.isCurrentOrPast = false
            self.selector = nil
        }
    }

    public static func iOS(_ version: iOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>) -> Self {
        Self(version)
    }

    public static func tvOS(_ version: tvOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>) -> Self {
        Self(version)
    }

    public static func macOS(_ version: macOSViewVersion<SwiftUIViewType, PlatformSpecificEntity>) -> Self {
        Self(version)
    }
}

public typealias iOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<iOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias tvOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<tvOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias macOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<macOSVersion, SwiftUIViewType, PlatformSpecificEntity>

public enum PlatformViewVersion<Version: PlatformVersion, SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    case available(Version, IntrospectionSelector<PlatformSpecificEntity>?)
    case unavailable

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
