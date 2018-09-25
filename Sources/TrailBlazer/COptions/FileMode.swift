/// A swift wrapper around the C mode_t type, which is used to hold/manipulate information about a Path's permissions
public struct FileMode: OptionSet, ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    public typealias IntegerLiteralType = OSUInt
    public typealias StringLiteralType = String

    public private(set)var rawValue: IntegerLiteralType

    /// The uid, gid, and sticky bits
    public var bits: FileBits {
        get { return FileBits(rawValue: (rawValue >> 9) & 0o7) }
        set {
            rawValue &= 0o0777
            rawValue |= newValue.rawValue << 9
        }
    }
    /// The permissions for the owner of the Path
    public var owner: FilePermissions {
        get { return FilePermissions(rawValue: (rawValue >> 6) & 0o7) }
        set {
            rawValue &= 0o7077
            rawValue |= newValue.rawValue << 6
        }
    }
    /// The permissions for members of the group of the Path
    public var group: FilePermissions {
        get { return FilePermissions(rawValue: (rawValue >> 3) & 0o7) }
        set {
            rawValue &= 0o7707
            rawValue |= newValue.rawValue << 3
        }
    }
    /// The permissions for others accessing the Path
    public var others: FilePermissions {
        get { return FilePermissions(rawValue: rawValue & 0o7) }
        set {
            rawValue &= 0o7770
            rawValue |= newValue.rawValue
        }
    }

    /// A FileMode with all permissions and all bits on
    public static let all: FileMode = 0o7777
    /// A FileMode with all permissions and no bits on
    public static let allPermissions: FileMode = 0o0777
    /// A FileMode with no permissions and all bits on
    public static let allBits: FileMode = 0o7000
    /// A FileMode with no permissions and no bits
    public static let none: FileMode = 0

    public init(rawValue: IntegerLiteralType) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)
    }

    /**
        Initialize from a Unix permissions string (-rwxrwxrwx)
    */
    public init(_ value: String) {
        self.init(rawValue: 0)
        guard [9, 10].contains(value.count) else { return }

        var value = value
        if value.count == 10 {
            value = String(value.dropFirst())
        }

        var raw: IntegerLiteralType = 0
        var sticky = false
        for (index, char) in value.enumerated() {
            if index % 3 == 0 {
                rawValue |= raw << (9 - index)
                raw = 0
                if sticky {
                    rawValue |= ((index / 3) == 1 ? FileBits.uid : FileBits.gid).rawValue << 9
                    sticky = false
                }
            }

            switch char {
            case "r": raw |= 0o4
            case "w": raw |= 0o2
            case "T": sticky = true
            case "S", "t":
                sticky = true
                fallthrough
            case "x": raw |= 0o1
            default: continue
            }
        }
        rawValue |= raw
        if sticky {
            rawValue |= FileBits.sticky.rawValue << 9
        }
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    private init(owner: IntegerLiteralType = 0, group: IntegerLiteralType = 0, others: IntegerLiteralType = 0, bits: IntegerLiteralType = 0) {
        var rawValue: IntegerLiteralType = bits << 9
        rawValue |= (owner << 6)
        rawValue |= (group << 3)
        rawValue |= others
        self.init(rawValue: rawValue)
    }

    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter owner: The permissions for the owner of the path
        - Parameter group: The permissions for members of the group of the path
        - Parameter others: The permissions for everyone else
        - Parameter bits: The uid, gid, and sticky bits

        NOTE: The default for each parameter is .none
    */
    public init(owner: FilePermissions = .none, group: FilePermissions = .none, others: FilePermissions = .none, bits: FileBits = .none) {
        self.init(owner: owner.rawValue, group: group.rawValue, others: others.rawValue, bits: bits.rawValue)
    }

    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter owner: The permissions for the owner of the path
        - Parameter group: The permissions for members of the group of the path
        - Parameter others: The permissions for everyone else
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func owner(_ owner: FilePermissions, group: FilePermissions = .none, others: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: owner.rawValue, group: group.rawValue, others: others.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter group: The permissions for members of the group of the path
        - Parameter owner: The permissions for the owner of the path
        - Parameter others: The permissions for everyone else
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func group(_ group: FilePermissions, owner: FilePermissions = .none, others: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: owner.rawValue, group: group.rawValue, others: others.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter others: The permissions for everyone else
        - Parameter owner: The permissions for the owner of the path
        - Parameter group: The permissions for members of the group of the path
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func others(_ others: FilePermissions, owner: FilePermissions = .none, group: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: owner.rawValue, group: group.rawValue, others: others.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter perms: The permissions for the owner and members of the group of the path
        - Parameter others: The permissions for everyone else
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func ownerGroup(_ perms: FilePermissions, others: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: perms.rawValue, group: perms.rawValue, others: others.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter perms: The permissions for the owner of the path and everyone else
        - Parameter group: The permissions for members of the group of the path
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func ownerOthers(_ perms: FilePermissions, group: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: perms.rawValue, group: group.rawValue, others: perms.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter group: The permissions for members of the group of the path and everyone else
        - Parameter owner: The permissions for the owner of the path
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func groupOthers(_ perms: FilePermissions, owner: FilePermissions = .none, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: owner.rawValue, group: perms.rawValue, others: perms.rawValue, bits: bits.rawValue)
    }
    /**
        Initializes a FileMode with the specified permissions and bits

        - Parameter perms: The permissions for everyone who accesses the path
        - Parameter bits: The uid, gid, and sticky bits
    */
    public static func ownerGroupOthers(_ perms: FilePermissions, bits: FileBits = .none) -> FileMode {
        return FileMode(owner: perms.rawValue, group: perms.rawValue, others: perms.rawValue, bits: bits.rawValue)
    }

    /**
    Determine if the current FileMode will be reduced by the process's umask

    - Returns: true if the FileMode is permitted by the umask
    */
    public func checkAgainstUMask() -> Bool {
        return self == unmasked()
    }

    /**
        Checks the FileMode against the umask (see umask(2))

        - Returns: The FileMode after disabling bits from the umask
    */
    public func unmasked() -> FileMode {
        return ~TrailBlazer.umask & rawValue
    }

    /// Mutates self to be the FileMode after disabling bits from the umask
    public mutating func unmask() {
        self &= ~TrailBlazer.umask
    }

    /// Returns the inverse FileMode with all bits flipped
    public static prefix func ~ (lhs: FileMode) -> FileMode {
        return FileMode(rawValue: ~lhs.rawValue)
    }

    /// Returns a FileMode with the bits contained in either mode
    public static func | (lhs: FileMode, rhs: FileMode) -> FileMode {
        return FileMode(rawValue: lhs.rawValue | rhs.rawValue)
    }
    /// Returns a FileMode with the bits contained in either mode
    public static func | (lhs: FileMode, rhs: FileBits) -> FileMode {
        return FileMode(rawValue: lhs.rawValue | (rhs.rawValue << 9))
    }
    /// Returns a FileMode with the bits contained in either mode
    public static func | (lhs: FileMode, rhs: IntegerLiteralType) -> FileMode {
        return FileMode(rawValue: lhs.rawValue | rhs)
    }
    /// Returns a FileMode with the bits contained in either mode
    public static func | (lhs: IntegerLiteralType, rhs: FileMode) -> FileMode {
        return FileMode(rawValue: lhs | rhs.rawValue)
    }

    /// Sets the FileMode with the bits contained in either mode
    public static func |= (lhs: inout FileMode, rhs: FileMode) {
        lhs = lhs | rhs
    }
    /// Sets the FileMode with the bits contained in either mode
    public static func |= (lhs: inout FileMode, rhs: FileBits) {
        lhs = lhs | rhs
    }
    /// Sets the FileMode with the bits contained in either mode
    public static func | (lhs: inout FileMode, rhs: IntegerLiteralType) {
        lhs = lhs | rhs
    }

    /// Returns a FileMode with only the bits contained in both modes
    public static func & (lhs: FileMode, rhs: FileMode) -> FileMode {
        return FileMode(rawValue: lhs.rawValue & rhs.rawValue)
    }
    /// Returns a FileMode with only the bits contained in both modes
    public static func & (lhs: FileMode, rhs: FileBits) -> FileMode {
        return FileMode(rawValue: lhs.rawValue & (rhs.rawValue << 9))
    }
    /// Returns a FileMode with only the bits contained in both modes
    public static func & (lhs: FileMode, rhs: IntegerLiteralType) -> FileMode {
        return FileMode(rawValue: lhs.rawValue & rhs)
    }
    /// Returns a FileMode with only the bits contained in both modes
    public static func & (lhs: IntegerLiteralType, rhs: FileMode) -> FileMode {
        return FileMode(rawValue: lhs & rhs.rawValue)
    }

    /// Sets the FileMode with only the bits contained in both modes
    public static func &= (lhs: inout FileMode, rhs: FileMode) {
        lhs = lhs & rhs
    }
    /// Sets the FileMode with only the bits contained in both modes
    public static func &= (lhs: inout FileMode, rhs: FileBits) {
        lhs = lhs & rhs
    }
    /// Sets the FileMode with only the bits contained in both modes
    public static func & (lhs: inout FileMode, rhs: IntegerLiteralType) {
        lhs = lhs & rhs
    }
}

extension FileMode: CustomStringConvertible {
    public var description: String {
        var str = "\(type(of: self))(owner: \(owner), group: \(group), others: \(others)"

        #if os(Linux)
        str += ", bits: \(bits)"
        #endif

        str += ")"

        return str
    }
}
