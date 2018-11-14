import struct Foundation.Date

extension UpdatableStatable {
    public var info: StatInfo {
        try? _info.getInfo()
        return _info
    }

    /// Whether or not the path is a directory
    public var isDirectory: Bool {
        return _info.exists && _info.type == .directory
    }

    /// Whether or not the path is a file
    public var isFile: Bool {
        return _info.exists && _info.type == .file
    }

    /// Whether or not the path is a symlink
    public var isLink: Bool {
        try? _info.getInfo(options: .getLinkInfo)
        return _info.exists && _info.type == .link
    }
}

extension Statable {
    /// Whether or not the path exists (or is accessible)
    public var exists: Bool {
        return info.exists
    }

    // swiftlint:disable identifier_name
    /// ID of device containing path
    public var id: DeviceID {
        return info.id
    }
    // swiftlint:enable identifier_name
    /// inode number
    public var inode: Inode {
        return info.inode
    }
    /// The type of the path
    public var type: PathType {
        return info.type
    }
    /// The path permissions
    public var permissions: FileMode {
        return info.permissions
    }
    /// user ID of owner
    public var owner: UID {
        return info.owner
    }
    /// group ID of owner
    public var group: GID {
        return info.group
    }
    /// device ID (if special file)
    public var device: DeviceID {
        return info.device
    }
    /// total size, in bytes
    public var size: OSOffsetInt {
        return info.size
    }
    /// blocksize for filesystem I/O
    public var blockSize: BlockSize {
        return info.blockSize
    }
    /// number of 512B blocks allocated
    public var blocks: OSOffsetInt {
        return info.blocks
    }

    /// time of last access
    public var lastAccess: Date {
        return info.lastAccess
    }
    /// time of last modification
    public var lastModified: Date {
        return info.lastModified
    }
    /// time of last status change
    public var lastAttributeChange: Date {
        return info.lastAttributeChange
    }
    #if os(macOS)
    /// time the path was created
    public var creation: Date {
        return info.creation
    }
    #endif
}