import SwiftUI

public struct PlatformViewVersions<SwiftUIViewType: IntrospectableViewType, PlatformView> {
    let isCurrent: Bool

    public static func iOS(_ versions: (iOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.isCurrent))
    }

    public static func tvOS(_ versions: (tvOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.isCurrent))
    }

    public static func macOS(_ versions: (macOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.isCurrent))
    }
}

public typealias iOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> = PlatformViewVersion<iOSVersion, SwiftUIViewType, PlatformView>
public typealias tvOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> = PlatformViewVersion<tvOSVersion, SwiftUIViewType, PlatformView>
public typealias macOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> = PlatformViewVersion<macOSVersion, SwiftUIViewType, PlatformView>

public struct PlatformViewVersion<Version: PlatformVersion, SwiftUIViewType: IntrospectableViewType, PlatformView> {
    let isCurrent: Bool
}

extension PlatformViewVersion {
    @_spi(Internals) public init(for version: Version) {
        self.init(isCurrent: version.isCurrent)
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
        return Self(isCurrent: false)
    }
}
