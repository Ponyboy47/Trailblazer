#if os(Linux)
import let Glibc.SOCK_STREAM
import let Glibc.SOCK_DGRAM
import struct Glibc.__socket_type
#else
import let Darwin.SOCK_STREAM
import let Darwin.SOCK_DGRAM
#endif

public struct SocketType: Hashable {
    let rawValue: OptionInt

    /// Provides sequenced, reliable, two-way, connection-based byte streams.
    /// An out-of-band data transmission mechanism may be supported.
    public static let stream = SocketType(rawValue: SOCK_STREAM)
    /// Supports datagrams (connectionless, unreliable messages of a fixed
    /// maximum length).
    public static let datagram = SocketType(rawValue: SOCK_DGRAM)

    private init(rawValue: UInt32) {
        self.rawValue = OptionInt(rawValue)
    }

    #if os(Linux)
    private init(rawValue: __socket_type) {
        self.init(rawValue: OptionInt(rawValue.rawValue))
    }
    #endif

    private init(rawValue: OptionInt) {
        self.rawValue = rawValue
    }
}