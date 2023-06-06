import SwiftUI

public struct PlatformViewVersions<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    let isCurrent: Bool
    let selector: IntrospectionSelector<PlatformSpecificEntity>?

    private init<Version: PlatformVersion>(
        _ versions: [PlatformViewVersion<Version, SwiftUIViewType, PlatformSpecificEntity>]
    ) {
        if let currentVersion = versions.first(where: \.isCurrent) {
            self.isCurrent = true
            self.selector = currentVersion.selector
        } else {
            self.isCurrent = false
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

public typealias iOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<iOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias tvOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<tvOSVersion, SwiftUIViewType, PlatformSpecificEntity>
public typealias macOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> =
    PlatformViewVersion<macOSVersion, SwiftUIViewType, PlatformSpecificEntity>

public struct PlatformViewVersion<Version: PlatformVersion, SwiftUIViewType: IntrospectableViewType, PlatformSpecificEntity: PlatformEntity> {
    let isCurrent: Bool
    let selector: IntrospectionSelector<PlatformSpecificEntity>?
}

extension PlatformViewVersion {
    @_spi(Internals) public init(for version: Version, selector: IntrospectionSelector<PlatformSpecificEntity>? = nil) {
        self.init(isCurrent: version.isCurrent, selector: selector)
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
        return Self(isCurrent: false, selector: nil)
    }
}
