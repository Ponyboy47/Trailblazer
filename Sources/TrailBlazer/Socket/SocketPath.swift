#if os(Linux)
import struct Glibc.sockaddr
import struct Glibc.sockaddr_un
import typealias Glibc.socklen_t
import func Glibc.strncpy
#else
import struct Darwin.sockaddr
import struct Darwin.sockaddr_un
import typealias Darwin.socklen_t
import func Darwin.strncpy
#endif

public typealias SocketAddress = sockaddr
public typealias SocketAddressSize = socklen_t
public typealias LocalSocketAddress = sockaddr_un
public typealias UnixSocketAddress = LocalSocketAddress

public struct SocketPath: Path {
    public static let pathType: PathType = .socket
    public static let emptyReadFlags: ReceiveFlags = .none
    public static let emptyWriteFlags: SendFlags = .none

    // swiftlint:disable identifier_name
    public var _path: String

    public let _info: StatInfo

    #if os(Linux)
    public static let PATH_MAX = 108
    #else
    public static let PATH_MAX = 104
    #endif
    // swiftlint:enable identifier_name

    /**
    Initialize from another Path

    - Parameter path: The path to copy
    */
    public init?(_ path: GenericPath) {
        // Cannot initialize a directory from a non-directory type
        if path.exists {
            guard path._info.type == .socket else { return nil }
        }

        _path = path._path
        _info = StatInfo(path)
        try? _info.getInfo()
    }

    public func convertToCAddress() throws -> (SocketAddress, SocketAddressSize) {
        guard string.count < SocketPath.PATH_MAX else {
            throw LocalAddressError.pathnameTooLong
        }

        var addr = LocalSocketAddress()

        let strlen = MemoryLayout.size(ofValue: addr.sun_path)
        withUnsafeMutablePointer(to: &addr.sun_path) {
            $0.withMemoryRebound(to: Int8.self, capacity: strlen) {
                _ = strncpy($0, string, strlen)
            }
        }

        return (unsafeBitCast(addr, to: SocketAddress.self), SocketAddressSize(MemoryLayout.size(ofValue: addr)))
    }

    @available(*, unavailable, message: "Cannot append to a SocketPath")
    public static func + <PathType: Path>(lhs: SocketPath, rhs: PathType) -> PathType {
        fatalError("Cannot append to a SocketPath")
    }
}