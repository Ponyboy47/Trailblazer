import func Cdirent.closedir
import func Cdirent.dirfd
import func Cdirent.opendir

#if os(Linux)
/// The directory stream type used for readding directory entries
public typealias DIRType = OpaquePointer
#else
import struct Cdirent.DIR

/// The directory stream type used for readding directory entries
public typealias DIRType = UnsafeMutablePointer<DIR>
#endif

extension DirectoryPath: Openable {
    public typealias Descriptor = DIRType

    /**
     Opens the directory

     - Returns: The opened directory

     - Throws: `OpenDirectoryError.permissionDenied` when the calling process does not have access to the path
     - Throws: `OpenDirectoryError.noProcessFileDescriptors` when the process has used all of its available file
                descriptors
     - Throws: `OpenDirectoryError.noSystemFileDescriptors` when the entire system has run out of available file
                descriptors
     - Throws: `OpenDirectoryError.pathDoesNotExist` when the path does not exist
     - Throws: `OpenDirectoryError.outOfMemory` when there is not enough available memory to open the directory
     - Throws: `OpenDirectoryError.pathNotDirectory` when the path you're trying to open exists and is not a directory.
                This should only occur if your DirectoryPath object was created before the path existed and then the path
                was created as a non-directory path type
     */
    public func open(options: Empty) throws -> Open<DirectoryPath> {
        guard let dir = opendir(string) else {
            throw OpenDirectoryError.getError()
        }

        return Open(self,
                    descriptor: dir,
                    fileDescriptor: dirfd(dir),
                    options: options) !! "Failed to set the opened directory"
    }

    /**
     Closes the directory, if open

     - Throws: Never
     */
    public static func close(opened: Open<DirectoryPath>) throws {
        guard let descriptor = opened.descriptor else {
            throw ClosedDescriptorError.alreadyClosed
        }
        guard closedir(descriptor) != -1 else {
            throw CloseDirectoryError.getError()
        }
    }
}
