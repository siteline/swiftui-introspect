import Foundation

public protocol PlatformVersion {
    var isCurrent: Bool { get }
}

public struct iOSVersion: PlatformVersion {
    public let isCurrent: Bool

    public init(isCurrent: () -> Bool) {
        self.isCurrent = isCurrent()
    }
}

extension iOSVersion {
    public static let v13 = iOSVersion {
        if #available(iOS 14, *) {
            return false
        }
        if #available(iOS 13, *) {
            return true
        }
        return false
    }

    public static let v14 = iOSVersion {
        if #available(iOS 15, *) {
            return false
        }
        if #available(iOS 14, *) {
            return true
        }
        return false
    }

    public static let v15 = iOSVersion {
        if #available(iOS 16, *) {
            return false
        }
        if #available(iOS 15, *) {
            return true
        }
        return false
    }

    public static let v16 = iOSVersion {
        if #available(iOS 17, *) {
            return false
        }
        if #available(iOS 16, *) {
            return true
        }
        return false
    }
}

public struct tvOSVersion: PlatformVersion {
    public let isCurrent: Bool

    public init(isCurrent: () -> Bool) {
        self.isCurrent = isCurrent()
    }
}

extension tvOSVersion {
    public static let v13 = tvOSVersion {
        if #available(tvOS 14, *) {
            return false
        }
        if #available(tvOS 13, *) {
            return true
        }
        return false
    }

    public static let v14 = tvOSVersion {
        if #available(tvOS 15, *) {
            return false
        }
        if #available(tvOS 14, *) {
            return true
        }
        return false
    }

    public static let v15 = tvOSVersion {
        if #available(tvOS 16, *) {
            return false
        }
        if #available(tvOS 15, *) {
            return true
        }
        return false
    }

    public static let v16 = tvOSVersion {
        if #available(tvOS 17, *) {
            return false
        }
        if #available(tvOS 16, *) {
            return true
        }
        return false
    }
}

public struct macOSVersion: PlatformVersion {
    public let isCurrent: Bool

    public init(isCurrent: () -> Bool) {
        self.isCurrent = isCurrent()
    }
}

extension macOSVersion {
    public static let v10_15 = macOSVersion {
        if #available(macOS 11, *) {
            return false
        }
        if #available(macOS 10.15, *) {
            return true
        }
        return false
    }

    public static let v11 = macOSVersion {
        if #available(macOS 12, *) {
            return false
        }
        if #available(macOS 11, *) {
            return true
        }
        return false
    }

    public static let v12 = macOSVersion {
        if #available(macOS 13, *) {
            return false
        }
        if #available(macOS 12, *) {
            return true
        }
        return false
    }

    public static let v13 = macOSVersion {
        if #available(macOS 14, *) {
            return false
        }
        if #available(macOS 13, *) {
            return true
        }
        return false
    }
}
