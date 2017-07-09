//
//  ExtractLocStringsTaskTests.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 27/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import XCTest

class ExtractLocStringsTaskTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    override func setUp() {
        TestDataSource.removeOutputDirectory()
        TestDataSource.createOutputDirectory()
    }
    
    override func tearDown() {
        TestDataSource.removeOutputDirectory()
    }
    
    // MARK: - Tests

    func testLaunch() {
        let result: Int32
        
        do {
            result = try TestDataSource.launchExtractLocStringsTask(objcFileName: TestDataSource.objcResource,
                                                                    swiftFileName: TestDataSource.swiftResource)
        }
        catch {
            result = -1
            print(error)
        }
        
        XCTAssert(result == 0, "Error from extractLocStrings: return code = \(result). See console logs for more information.")
        
        let swiftCustomTablePath = TestDataSource.outputDirectory.appending("/TestSwiftClass.strings")
        let swiftCustomTableExists = FileManager.default.fileExists(atPath: swiftCustomTablePath)
        
        XCTAssert(swiftCustomTableExists == true)
        
        let objcCustomTablePath = TestDataSource.outputDirectory.appending("/TestObjCClass.strings")
        let objcCustomTableExists = FileManager.default.fileExists(atPath: objcCustomTablePath)
        
        XCTAssert(objcCustomTableExists == true)
    }
    
}
