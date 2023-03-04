import SwiftUI

public struct PlatformDescriptor<SwiftUIView: ViewType, PlatformView> {
    typealias IntrospectingView = (@escaping (PlatformView) -> Void) -> AnyView

    let introspectingView: IntrospectingView?
}

extension PlatformDescriptor {
    public static func iOS(_ versions: (PlatformVersionDescriptor<iOSVersion, SwiftUIView, PlatformView>)...) -> Self {
        Self(introspectingView: versions.lazy.compactMap(\.introspectingView).first)
    }

    public static func macOS(_ versions: (PlatformVersionDescriptor<macOSVersion, SwiftUIView, PlatformView>)...) -> Self {
        Self(introspectingView: versions.lazy.compactMap(\.introspectingView).first)
    }

    public static func tvOS(_ versions: (PlatformVersionDescriptor<tvOSVersion, SwiftUIView, PlatformView>)...) -> Self {
        Self(introspectingView: versions.lazy.compactMap(\.introspectingView).first)
    }
}

public struct PlatformVersionDescriptor<Version: PlatformVersion, SwiftUIView: ViewType, PlatformView> {
    typealias IntrospectingView = (@escaping (PlatformView) -> Void) -> AnyView

    private let version: Version
    private let _introspectingView: IntrospectingView

    init<IntrospectingView: View>(
        for version: Version,
        introspectingView: @escaping (@escaping (PlatformView) -> Void) -> IntrospectingView
    ) {
        self.version = version
        self._introspectingView = { customize in AnyView(introspectingView(customize)) }
    }

    init(
        for version: Version,
        sameAs other: Self
    ) {
        self.init(for: version, introspectingView: other._introspectingView)
    }

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
        return Self(for: version) { _ in EmptyView() }
    }

    var introspectingView: IntrospectingView? {
        if version.isCurrent {
            return _introspectingView
        } else {
            return nil
        }
    }
}
