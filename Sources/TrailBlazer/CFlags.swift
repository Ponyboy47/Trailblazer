#if os(Linux)
import Glibc
public typealias OSInt = Int
public typealias OSUInt = UInt32
#else
import Darwin
public typealias OSInt = Int64
public typealias OSUInt = UInt16
#endif
public typealias OptionInt = Int32
public typealias FileDescriptor = Int32

public struct OpenFilePermissions: Equatable, CustomStringConvertible {
    public let rawValue: OptionInt
    public var description: String {
        if self == .read {
            return "\(type(of: self))(read)"
        } else if self == .write {
            return "\(type(of: self))(write)"
        } else if self == .readWrite {
            return "\(type(of: self))(readWrite)"
        } else {
            return "\(type(of: self))(unknown)"
        }
    }

    public static let read = OpenFilePermissions(rawValue: O_RDONLY)
    public static let write = OpenFilePermissions(rawValue: O_WRONLY)
    public static let readWrite = OpenFilePermissions(rawValue: O_RDWR)

    private init(rawValue: OptionInt) {
        self.rawValue = rawValue
    }

    public static func == (lhs: OpenFilePermissions, rhs: OpenFilePermissions) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public func contains(_ perms: OpenFilePermissions) -> Bool {
        guard self != .readWrite else { return true }

        return self == perms
    }
}

public struct OpenFileFlags: OptionSet, CustomStringConvertible {
    public let rawValue: OptionInt
    public var description: String {
        var flags: [String] = []

        if contains(.append) {
            flags.append("append")
        }
        if contains(.async) {
            flags.append("async")
        }
        if contains(.closeOnExec) {
            flags.append("closeOnExec")
        }
        if contains(.create) {
            flags.append("create")
        }
        if contains(.directory) {
            flags.append("directory")
        }
        if contains(.excl) {
            flags.append("excl")
        }
        if contains(.noCTTY) {
            flags.append("noCTTY")
        }
        if contains(.noFollow) {
            flags.append("noFollow")
        }
        if contains(.nonBlock) {
            flags.append("nonBlock")
        }
        if contains(.nDelay) {
            flags.append("nDelay")
        }
        if contains(.truncate) {
            flags.append("truncate")
        }
        #if os(Linux)
        if contains(.dsync) {
            flags.append("dsync")
        }
        if contains(.sync) {
            flags.append("sync")
        }
        #else
        if contains(.sharedLock) {
            flags.append("sharedLock")
        }
        if contains(.exclusiveLock) {
            flags.append("exclusiveLock")
        }
        if contains(.symlink) {
            flags.append("symlink")
        }
        if contains(.evtOnly) {
            flags.append("evtOnly")
        }
        #endif

        return "\(type(of: self))(\(flags.joined(separator: ", ")))"
    }

    public static let append = OpenFileFlags(rawValue: O_APPEND)
    public static let async = OpenFileFlags(rawValue: O_ASYNC)
    public static let closeOnExec = OpenFileFlags(rawValue: O_CLOEXEC)
    public static let create = OpenFileFlags(rawValue: O_CREAT)
    public static let directory = OpenFileFlags(rawValue: O_DIRECTORY)
    public static let excl = OpenFileFlags(rawValue: O_EXCL)
    public static let noCTTY = OpenFileFlags(rawValue: O_NOCTTY)
    public static let noFollow = OpenFileFlags(rawValue: O_NOFOLLOW)
    public static let nonBlock = OpenFileFlags(rawValue: O_NONBLOCK)
    public static let nDelay = OpenFileFlags(rawValue: O_NDELAY)
    public static let truncate = OpenFileFlags(rawValue: O_TRUNC)
    #if os(Linux)
    public static let dsync = OpenFileFlags(rawValue: O_DSYNC)
    public static let sync = OpenFileFlags(rawValue: O_SYNC)
    #else
    public static let sharedLock = OpenFileFlags(rawValue: O_SHLOCK)
    public static let exclusiveLock = OpenFileFlags(rawValue: O_EXLOCK)
    public static let symlink = OpenFileFlags(rawValue: O_SYMLINK)
    public static let evtOnly = OpenFileFlags(rawValue: O_EVTONLY)
    #endif

    public init(rawValue: OptionInt) {
        self.rawValue = rawValue
    }
}

public struct FilePermissions: OptionSet, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias IntegerLiteralType = OSUInt

    public let rawValue: IntegerLiteralType
    public var description: String {
        var perms: [String] = []

        if contains(.read) {
            perms.append("read")
        }
        if contains(.write) {
            perms.append("write")
        }
        if contains(.execute) {
            perms.append("execute")
        }

        return "\(type(of: self))(\(perms.joined(separator: ", ")))"
    }

    public static let read = FilePermissions(rawValue: 0o4)
    public static let write = FilePermissions(rawValue: 0o2)
    public static let execute = FilePermissions(rawValue: 0o1)

    public var hasNone: Bool { return !(contains(.read) || contains(.write) || contains(.execute)) }

    public init(rawValue: IntegerLiteralType = 0) {
        self.rawValue = rawValue
    }

    public init(_ perms: FilePermissions...) {
        rawValue = perms.reduce(0, { $0 | $1.rawValue })
    }

    public init(_ value: String) {
        guard value.count == 3 else { self.init(); return }

        var value = value
        var perms: IntegerLiteralType = 0

        if (value.hasPrefix("r")) {
            perms |= 0o4
        }

        value = String(value.dropFirst())
        if (value.hasPrefix("w")) {
            perms |= 0o2
        }

        value = String(value.dropFirst())
        if (value.hasPrefix("x")) {
            perms |= 0o1
        }
        self.init(rawValue: perms)
    }

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(value)
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }
}

public struct FileMode: OptionSet, CustomStringConvertible, ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = OSUInt

    public let rawValue: IntegerLiteralType

    // #if os(Linux)
    public let uid: Bool = false
    public let gid: Bool = false
    public let sticky: Bool = false
    // #endif

    public var description: String {
        var str = "\(type(of: self))(owner: \(owner), group: \(group), others: \(others)"

        #if os(Linux)
        str += ", uid: \(uid), gid: \(gid), sticky: \(sticky)"
        #endif

        str += ")"

        return str
    }

    public var owner: FilePermissions {
        return FilePermissions(rawValue: rawValue >> 6)
    }
    public var group: FilePermissions {
        return FilePermissions(rawValue: rawValue >> 3)
    }
    public var others: FilePermissions {
        return FilePermissions(rawValue: rawValue)
    }

    public init(rawValue: IntegerLiteralType) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }

    private init(owner: IntegerLiteralType = 0, group: IntegerLiteralType = 0, others: IntegerLiteralType = 0, uid: Bool = false, gid: Bool = false, sticky: Bool = false) {
        precondition((owner | group | others) != 0)
        var rawValue: IntegerLiteralType = uid ? 4 : 0
        rawValue |= gid ? 2 : 0
        rawValue |= sticky ? 1 : 0
        rawValue <<= 9
        rawValue |= (owner << 6)
        rawValue |= (group << 3)
        rawValue |= others
        self.init(rawValue: rawValue)
    }

    public init(owner: FilePermissions = [], group: FilePermissions = [], others: FilePermissions = [], uid: Bool = false, gid: Bool = false, sticky: Bool = false) {
        self.init(owner: owner.rawValue, group: group.rawValue, others: others.rawValue, uid: uid, gid: gid, sticky: sticky)
    }

    public static func owner(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        return FileMode(owner: perms.reduce(0, { $0 | $1.rawValue }), uid: uid, gid: gid, sticky: sticky)
    }
    public static func group(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        return FileMode(group: perms.reduce(0, { $0 | $1.rawValue }), uid: uid, gid: gid, sticky: sticky)
    }
    public static func others(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        return FileMode(others: perms.reduce(0, { $0 | $1.rawValue }), uid: uid, gid: gid, sticky: sticky)
    }
    public static func ownerGroup(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        let raw = perms.reduce(0, { $0 | $1.rawValue })
        return FileMode(owner: raw, group: raw, uid: uid, gid: gid, sticky: sticky)
    }
    public static func ownerOthers(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        let raw = perms.reduce(0, { $0 | $1.rawValue })
        return FileMode(owner: raw, others: raw, uid: uid, gid: gid, sticky: sticky)
    }
    public static func groupOthers(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        let raw = perms.reduce(0, { $0 | $1.rawValue })
        return FileMode(group: raw, others: raw, uid: uid, gid: gid, sticky: sticky)
    }
    public static func ownerGroupOthers(_ perms: FilePermissions..., uid: Bool = false, gid: Bool = false, sticky: Bool = false) -> FileMode {
        let raw = perms.reduce(0, { $0 | $1.rawValue })
        return FileMode(owner: raw, group: raw, others: raw, uid: uid, gid: gid, sticky: sticky)
    }
}
