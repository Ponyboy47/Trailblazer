import XCTest

extension BindingTests {
    static let __allTests = [
        ("testAccepting", testAccepting),
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testEquatable", testEquatable),
        ("testHashable", testHashable)
    ]
}

extension ChmodTests {
    static let __allTests = [
        ("testOpenFile", testOpenFile),
        ("testRecursive", testRecursive),
        ("testSetGroup", testSetGroup),
        ("testSetGroupOthers", testSetGroupOthers),
        ("testSetOthers", testSetOthers),
        ("testSetOwner", testSetOwner),
        ("testSetOwnerGroup", testSetOwnerGroup),
        ("testSetOwnerGroupOthers", testSetOwnerGroupOthers),
        ("testSetOwnerOthers", testSetOwnerOthers),
        ("testSetProperties", testSetProperties)
    ]
}

extension ChownTests {
    static let __allTests = [
        ("testSetBoth", testSetBoth),
        ("testSetGroup", testSetGroup),
        ("testSetNeither", testSetNeither),
        ("testSetOpen", testSetOpen),
        ("testSetOwner", testSetOwner),
        ("testSetRecursive", testSetRecursive),
        ("testSetString", testSetString)
    ]
}

extension CopyTests {
    static let __allTests = [
        ("testCopyDirectoryEmpty", testCopyDirectoryEmpty),
        ("testCopyDirectoryNotEmpty", testCopyDirectoryNotEmpty),
        ("testCopyDirectoryRecursive", testCopyDirectoryRecursive),
        ("testCopyFile", testCopyFile)
    ]
}

extension CreateDeleteTests {
    static let __allTests = [
        ("testCreateDirectory", testCreateDirectory),
        ("testCreateFile", testCreateFile),
        ("testCreateIntermediates", testCreateIntermediates),
        ("testCreateWithClosure", testCreateWithClosure),
        ("testCreateWithContents", testCreateWithContents),
        ("testDeleteDirectory", testDeleteDirectory),
        ("testDeleteDirectoryRecursive", testDeleteDirectoryRecursive),
        ("testDeleteFile", testDeleteFile),
        ("testDeleteNonEmptyDirectory", testDeleteNonEmptyDirectory)
    ]
}

extension DirectoryChildrenTests {
    static let __allTests = [
        ("testEmpty", testEmpty),
        ("testEquality", testEquality),
        ("testNotEmpty", testNotEmpty),
        ("testPlus", testPlus),
        ("testPlusEqual", testPlusEqual)
    ]
}

extension FileBitsTests {
    static let __allTests = [
        ("testAndOperator", testAndOperator),
        ("testContains", testContains),
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testEquality", testEquality),
        ("testHasNone", testHasNone),
        ("testNotOperator", testNotOperator),
        ("testOrOperator", testOrOperator)
    ]
}

extension FileModeTests {
    static let __allTests = [
        ("testAndOperator", testAndOperator),
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testGidBit", testGidBit),
        ("testGidStickyBits", testGidStickyBits),
        ("testGroupExecute", testGroupExecute),
        ("testGroupOthersExecute", testGroupOthersExecute),
        ("testGroupOthersRead", testGroupOthersRead),
        ("testGroupOthersReadExecute", testGroupOthersReadExecute),
        ("testGroupOthersReadWrite", testGroupOthersReadWrite),
        ("testGroupOthersReadWriteExecute", testGroupOthersReadWriteExecute),
        ("testGroupOthersWrite", testGroupOthersWrite),
        ("testGroupOthersWriteExecute", testGroupOthersWriteExecute),
        ("testGroupRead", testGroupRead),
        ("testGroupReadExecute", testGroupReadExecute),
        ("testGroupReadWrite", testGroupReadWrite),
        ("testGroupReadWriteExecute", testGroupReadWriteExecute),
        ("testGroupWrite", testGroupWrite),
        ("testGroupWriteExecute", testGroupWriteExecute),
        ("testOrOperator", testOrOperator),
        ("testOSStrings", testOSStrings),
        ("testOthersExecute", testOthersExecute),
        ("testOthersRead", testOthersRead),
        ("testOthersReadExecute", testOthersReadExecute),
        ("testOthersReadWrite", testOthersReadWrite),
        ("testOthersReadWriteExecute", testOthersReadWriteExecute),
        ("testOthersWrite", testOthersWrite),
        ("testOthersWriteExecute", testOthersWriteExecute),
        ("testOwnerExecute", testOwnerExecute),
        ("testOwnerGroupExecute", testOwnerGroupExecute),
        ("testOwnerGroupOthersExecute", testOwnerGroupOthersExecute),
        ("testOwnerGroupOthersRead", testOwnerGroupOthersRead),
        ("testOwnerGroupOthersReadExecute", testOwnerGroupOthersReadExecute),
        ("testOwnerGroupOthersReadWrite", testOwnerGroupOthersReadWrite),
        ("testOwnerGroupOthersReadWriteExecute", testOwnerGroupOthersReadWriteExecute),
        ("testOwnerGroupOthersWrite", testOwnerGroupOthersWrite),
        ("testOwnerGroupOthersWriteExecute", testOwnerGroupOthersWriteExecute),
        ("testOwnerGroupRead", testOwnerGroupRead),
        ("testOwnerGroupReadExecute", testOwnerGroupReadExecute),
        ("testOwnerGroupReadWrite", testOwnerGroupReadWrite),
        ("testOwnerGroupReadWriteExecute", testOwnerGroupReadWriteExecute),
        ("testOwnerGroupWrite", testOwnerGroupWrite),
        ("testOwnerGroupWriteExecute", testOwnerGroupWriteExecute),
        ("testOwnerOthersExecute", testOwnerOthersExecute),
        ("testOwnerOthersRead", testOwnerOthersRead),
        ("testOwnerOthersReadExecute", testOwnerOthersReadExecute),
        ("testOwnerOthersReadWrite", testOwnerOthersReadWrite),
        ("testOwnerOthersReadWriteExecute", testOwnerOthersReadWriteExecute),
        ("testOwnerOthersWrite", testOwnerOthersWrite),
        ("testOwnerOthersWriteExecute", testOwnerOthersWriteExecute),
        ("testOwnerRead", testOwnerRead),
        ("testOwnerReadExecute", testOwnerReadExecute),
        ("testOwnerReadWrite", testOwnerReadWrite),
        ("testOwnerReadWriteExecute", testOwnerReadWriteExecute),
        ("testOwnerWrite", testOwnerWrite),
        ("testOwnerWriteExecute", testOwnerWriteExecute),
        ("testSetFileBits", testSetFileBits),
        ("testStickyBit", testStickyBit),
        ("testUidBit", testUidBit),
        ("testUidGidBits", testUidGidBits),
        ("testUidGidStickyBits", testUidGidStickyBits),
        ("testUidStickyBits", testUidStickyBits),
        ("testUMask", testUMask),
        ("testUnmask", testUnmask)
    ]
}

extension FilePermissionsTests {
    static let __allTests = [
        ("testAndOperator", testAndOperator),
        ("testExecute", testExecute),
        ("testNone", testNone),
        ("testNotOperator", testNotOperator),
        ("testOrOperator", testOrOperator),
        ("testRead", testRead),
        ("testReadExecute", testReadExecute),
        ("testReadWrite", testReadWrite),
        ("testReadWriteExecute", testReadWriteExecute),
        ("testWrite", testWrite),
        ("testWriteExecute", testWriteExecute)
    ]
}

extension GlobTests {
    static let __allTests = [
        ("testGlob", testGlob),
        ("testGlobDirectory", testGlobDirectory),
        ("testGlobFlagsCustomStringConvertible", testGlobFlagsCustomStringConvertible),
        ("testGlobFlagsInit", testGlobFlagsInit)
    ]
}

extension LinkTests {
    static let __allTests = [
        ("testAbsoluteHardLink", testAbsoluteHardLink),
        ("testAbsoluteSoftLink", testAbsoluteSoftLink),
        ("testDirectoryEnumerable", testDirectoryEnumerable),
        ("testFromLinking", testFromLinking),
        ("testInits", testInits),
        ("testOpenClosures", testOpenClosures),
        ("testOpenDirectory", testOpenDirectory),
        ("testOpenFile", testOpenFile),
        ("testRelativeHardLink", testRelativeHardLink),
        ("testRelativeSoftLink", testRelativeSoftLink)
    ]
}

extension MoveTests {
    static let __allTests = [
        ("testMove", testMove),
        ("testMoveInto", testMoveInto),
        ("testRename", testRename)
    ]
}

extension OpenTests {
    static let __allTests = [
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testGetCharacter", testGetCharacter),
        ("testGetDirectoryChildren", testGetDirectoryChildren),
        ("testGetLine", testGetLine),
        ("testHashable", testHashable),
        ("testOpenDirectory", testOpenDirectory),
        ("testOpenDirectoryClosure", testOpenDirectoryClosure),
        ("testOpenDirectoryOptions", testOpenDirectoryOptions),
        ("testOpenFile", testOpenFile),
        ("testOpenFileClosure", testOpenFileClosure),
        ("testOpenFileModeCustomStringConvertible", testOpenFileModeCustomStringConvertible),
        ("testOpenFileOptions", testOpenFileOptions),
        ("testReadDifferentBuffersFile", testReadDifferentBuffersFile),
        ("testReadFile", testReadFile),
        ("testReadThenWrite", testReadThenWrite),
        ("testSeek", testSeek),
        ("testSeekReadWrite", testSeekReadWrite),
        ("testSeekStatic", testSeekStatic),
        ("testSeekStaticReadWrite", testSeekStaticReadWrite),
        ("testStandardStreams", testStandardStreams),
        ("testUngetCharacter", testUngetCharacter),
        ("testURL", testURL),
        ("testWriteFile", testWriteFile),
        ("testWriteThenRead", testWriteThenRead)
    ]
}

extension PathTests {
    static let __allTests = [
        ("testAbsolute", testAbsolute),
        ("testAddable", testAddable),
        ("testAncestors", testAncestors),
        ("testArrayInit", testArrayInit),
        ("testArrayLiteral", testArrayLiteral),
        ("testArraySliceInit", testArraySliceInit),
        ("testAutoOpenFunctions", testAutoOpenFunctions),
        ("testChangeSeparator", testChangeSeparator),
        ("testChCWD", testChCWD),
        ("testCodable", testCodable),
        ("testComparable", testComparable),
        ("testComponents", testComponents),
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testEquatable", testEquatable),
        ("testExists", testExists),
        ("testExpand", testExpand),
        ("testGenericPathMath", testGenericPathMath),
        ("testGetHome", testGetHome),
        ("testIses", testIses),
        ("testIsLink", testIsLink),
        ("testIterator", testIterator),
        ("testLastComponent", testLastComponent),
        ("testLastComponentWithoutExtension", testLastComponentWithoutExtension),
        ("testParent", testParent),
        ("testPathInit", testPathInit),
        ("testPathType", testPathType),
        ("testPathTypeInits", testPathTypeInits),
        ("testRelative", testRelative),
        ("testSetParent", testSetParent),
        ("testStringInit", testStringInit),
        ("testStringLiteral", testStringLiteral),
        ("testVariadicInit", testVariadicInit)
    ]
}

extension StatTests {
    static let __allTests = [
        ("testAccess", testAccess),
        ("testAttributeChange", testAttributeChange),
        ("testBlocks", testBlocks),
        ("testBlockSize", testBlockSize),
        ("testCreation", testCreation),
        ("testCustomStringConvertible", testCustomStringConvertible),
        ("testDelegate", testDelegate),
        ("testDevice", testDevice),
        ("testGroup", testGroup),
        ("testID", testID),
        ("testInit", testInit),
        ("testInode", testInode),
        ("testModified", testModified),
        ("testOwner", testOwner),
        ("testPermissions", testPermissions),
        ("testSize", testSize),
        ("testStatDelegate", testStatDelegate),
        ("testType", testType)
    ]
}

extension TemporaryTests {
    static let __allTests = [
        ("testTemporaryDirectory", testTemporaryDirectory),
        ("testTemporaryFile", testTemporaryFile),
        ("testTemporaryWithClosure", testTemporaryWithClosure)
    ]
}

extension UtilityTests {
    static let __allTests = [
        ("testGigabytes", testGigabytes),
        ("testKilobytes", testKilobytes),
        ("testMegabytes", testMegabytes),
        ("testPetabytes", testPetabytes),
        ("testTerabytes", testTerabytes)
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BindingTests.__allTests),
        testCase(ChmodTests.__allTests),
        testCase(ChownTests.__allTests),
        testCase(CopyTests.__allTests),
        testCase(CreateDeleteTests.__allTests),
        testCase(DirectoryChildrenTests.__allTests),
        testCase(FileBitsTests.__allTests),
        testCase(FileModeTests.__allTests),
        testCase(FilePermissionsTests.__allTests),
        testCase(GlobTests.__allTests),
        testCase(LinkTests.__allTests),
        testCase(MoveTests.__allTests),
        testCase(OpenTests.__allTests),
        testCase(PathTests.__allTests),
        testCase(StatTests.__allTests),
        testCase(TemporaryTests.__allTests),
        testCase(UtilityTests.__allTests)
    ]
}
#endif
