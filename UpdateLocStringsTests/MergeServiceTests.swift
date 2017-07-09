//
//  MergeServiceTests.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 04/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import XCTest

class MergeServiceTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    override func setUp() {
        TestDataSource.removeOutputDirectory()
        TestDataSource.createOutputDirectory()
    }
    
    override func tearDown() {
        TestDataSource.removeOutputDirectory()
    }
    
    // MARK: - Private methods
    
    @discardableResult
    private func generateStringsFile(objcFileName: String, swiftFileName: String) -> [String] {
        let stringsFiles: [String]
        do {
            try TestDataSource.launchExtractLocStringsTask(objcFileName: objcFileName,
                                                           swiftFileName: swiftFileName)
            let files = try FileManager.default.contentsOfDirectory(atPath: TestDataSource.outputDirectory)
            stringsFiles = files.filter { $0.hasSuffix(".strings") }
        }
        catch {
            stringsFiles = []
            print(error)
        }
        return stringsFiles
    }

    // MARK: - Tests
    
    func testPrepareForMerge() {
        let stringsFiles = generateStringsFile(objcFileName: TestDataSource.objcResource,
                                               swiftFileName: TestDataSource.swiftResource)
        XCTAssertTrue(stringsFiles.count > 0)
        
        let service = MergeService(outputDirectory: TestDataSource.outputDirectory)
        do {
            try service.prepareForMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        let preparedFiles: [String]
        let preparedFileExtension = ".merge_old"
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: TestDataSource.outputDirectory)
            preparedFiles = files.filter { $0.hasSuffix(preparedFileExtension) }
        }
        catch {
            preparedFiles = []
            print(error)
        }
        
        XCTAssertTrue(preparedFiles.count > 0)
        
        for originalFile in stringsFiles {
            let preparedFile = originalFile.appending(preparedFileExtension)
            XCTAssertTrue(preparedFiles.contains(preparedFile))
        }
    }
    
    func testPrepareForMergeWithEmptyFolder() {
        let service = MergeService(outputDirectory: TestDataSource.outputDirectory)
        do {
            try service.prepareForMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        let preparedFileExtension = ".merge_old"
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: TestDataSource.outputDirectory)
            let preparedFiles = files.filter { $0.hasSuffix(preparedFileExtension) }
            XCTAssertTrue(preparedFiles.count == 0)
        }
        catch {
            print(error)
            XCTFail()
        }
    }

    func testMerge() {
        let stringsFiles = generateStringsFile(objcFileName: TestDataSource.objcResource,
                                               swiftFileName: TestDataSource.swiftResource)
        XCTAssertTrue(stringsFiles.count > 0)
        
        let service = MergeService(outputDirectory: TestDataSource.outputDirectory)
        do {
            try service.prepareForMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        let updatedStringsFiles = generateStringsFile(objcFileName: TestDataSource.objcUpdatedResource,
                                               swiftFileName: TestDataSource.swiftUpdatedResource)
        XCTAssertTrue(updatedStringsFiles.count > 0)
        
        do {
            try service.performMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        let localizedStingsPath = TestDataSource.outputDirectory.appending("/Localizable.strings")
        let localizedStrings: [LocalizedString]
        
        do {
            localizedStrings = try StringsFileParser.parse(contentOf: localizedStingsPath)
        }
        catch {
            localizedStrings = []
            print(error)
            XCTFail()
        }
        
        XCTAssertTrue(localizedStrings.count == 5)
        
        // Check all comments
        
        for string in localizedStrings {
            XCTAssertTrue(string.comment.hasPrefix("Updated"))
        }
        
        // Check value
        
        let firstString = localizedStrings[0]
        XCTAssertTrue(firstString.value == "TestObjCClass.firstString", "string exist before merge (should keep old value)")
        
        let secondString = localizedStrings[1]
        XCTAssertTrue(secondString.value == "default value", "string exist before merge (should keep old value)")
        
        let thirdString = localizedStrings[2]
        XCTAssertTrue(thirdString.value == "Updated default value", "new string from updated source")
        
        let fourthString = localizedStrings[3]
        XCTAssertTrue(fourthString.value == "TestSwiftClass.firstString", "string exist before merge (should keep old value)")
        
        let fifthString = localizedStrings[4]
        XCTAssertTrue(fifthString.value == "default value", "string exist before merge (should keep old value)")
    }
    
    func testCompleteMerge() {
        generateStringsFile(objcFileName: TestDataSource.objcResource,
                            swiftFileName: TestDataSource.swiftResource)
        let service = MergeService(outputDirectory: TestDataSource.outputDirectory)
        do {
            try service.prepareForMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        generateStringsFile(objcFileName: TestDataSource.objcUpdatedResource,
                            swiftFileName: TestDataSource.swiftUpdatedResource)
        
        do {
            try service.performMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        do {
            try service.completeMerge()
        }
        catch {
            print(error)
            XCTFail()
        }
        
        let preparedFileExtension = ".merge_old"
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: TestDataSource.outputDirectory)
            let preparedFiles = files.filter { $0.hasSuffix(preparedFileExtension) }
            XCTAssertTrue(preparedFiles.count == 0)
        }
        catch {
            print(error)
            XCTFail()
        }
    }

}
