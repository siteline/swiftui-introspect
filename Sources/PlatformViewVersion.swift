import SwiftUI

public struct PlatformViewVersions<SwiftUIViewType: ViewType, PlatformView> {
    let isCurrent: Bool

    public static func iOS(_ versions: (iOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.version.isCurrent))
    }

    public static func tvOS(_ versions: (tvOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.version.isCurrent))
    }

    public static func macOS(_ versions: (macOSViewVersion<SwiftUIViewType, PlatformView>)...) -> Self {
        Self(isCurrent: versions.contains(where: \.version.isCurrent))
    }
}

public typealias iOSViewVersion<SwiftUIViewType: ViewType, PlatformView> = PlatformViewVersion<iOSVersion, SwiftUIViewType, PlatformView>

public typealias tvOSViewVersion<SwiftUIViewType: ViewType, PlatformView> = PlatformViewVersion<tvOSVersion, SwiftUIViewType, PlatformView>

public typealias macOSViewVersion<SwiftUIViewType: ViewType, PlatformView> = PlatformViewVersion<macOSVersion, SwiftUIViewType, PlatformView>

public struct PlatformViewVersion<Version: PlatformVersion, SwiftUIViewType: ViewType, PlatformView> {
    let version: Version

    @_spi(Internals) public init(for version: Version) {
        self.version = version
    }

    // TODO: do we need this? It's an interesting idea to be exhaustive about API availability per platform version, but maybe not having it in the first place is clearer? Plus we get rid of RuntimeWarnings.swift...
    static func unavailable(
        for version: Version,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self {
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
        return Self(for: version)
    }
}