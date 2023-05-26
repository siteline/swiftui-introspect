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

public struct iOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> {
    let version: iOSVersion?
    var isCurrent: Bool { version?.isCurrent ?? false }
}

extension iOSViewVersion {
    public init(for version: iOSVersion) {
        self.init(version: version)
    }

    public static func unavailable(file: StaticString = #file, line: UInt = #line) -> Self {
        warnUnavailablePlatform(file: file, line: line)
        return Self(version: nil)
    }
}

public struct tvOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> {
    let version: tvOSVersion?
    var isCurrent: Bool { version?.isCurrent ?? false }
}

extension tvOSViewVersion {
    public init(for version: tvOSVersion) {
        self.init(version: version)
    }

    public static func unavailable(file: StaticString = #file, line: UInt = #line) -> Self {
        warnUnavailablePlatform(file: file, line: line)
        return Self(version: nil)
    }
}

public struct macOSViewVersion<SwiftUIViewType: IntrospectableViewType, PlatformView> {
    let version: macOSVersion?
    var isCurrent: Bool { version?.isCurrent ?? false }
}

extension macOSViewVersion {
    public init(for version: macOSVersion) {
        self.init(version: version)
    }

    public static func unavailable(file: StaticString = #file, line: UInt = #line) -> Self {
        warnUnavailablePlatform(file: file, line: line)
        return Self(version: nil)
    }
}

fileprivate func warnUnavailablePlatform(file: StaticString = #file, line: UInt = #line) {
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
}
