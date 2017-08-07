//
//  TestDataSource.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 04/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

final class TestDataSource {
    
    // MARK: - Errors
    
    enum DataSourceError: Error {
        case objcSourceFileMissing
        case swiftSourceFileMissing
    }
    
    // MARK: - Internal static properties
    
    static let testDataDirectory = "TestData"
    static let documentsDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    static let outputDirectory = NSString(string: "\(documentsDir)/UpdateLocStringsTests").expandingTildeInPath
    
    static let objcResource = "TestObjCClass"
    static let objcUpdatedResource = "TestUpdatedObjCClass"
    static let objcType = "m"
    
    static let swiftResource = "TestSwiftClass"
    static let swiftUpdatedResource = "TestUpdatedSwiftClass"
    static let swiftType = "swift"
    
    static let stringsResource = "TestLocalizable"
    static let unusedStringsResource = "UnusedStrings"
    static let stringsType = "strings"
    
    // MARK: - Internal static methods
    
    static func createOutputDirectory() {
        if FileManager.default.fileExists(atPath: outputDirectory, isDirectory: nil) {
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: outputDirectory,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        }
        catch {
            print(error)
        }
    }
    
    static func removeOutputDirectory() {
        if !FileManager.default.fileExists(atPath: outputDirectory, isDirectory: nil) {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: outputDirectory)
        }
        catch {
            print(error)
        }
    }
    
    @discardableResult
    static func launchExtractLocStringsTask(objcFileName: String, swiftFileName: String) throws -> Int32 {
        // Objective-C source file with localizable strings
        
        guard let objcFilePath = pathForTestDataResource(objcFileName, ofType: objcType) else {
            throw DataSourceError.objcSourceFileMissing
        }
        
        // Swift source file with localizable strings
        
        guard let swiftFilePath = pathForTestDataResource(swiftFileName, ofType: swiftType) else {
            throw DataSourceError.swiftSourceFileMissing
        }
        
        // Task launch
        
        let argumets = [ objcFilePath, swiftFilePath, "-o", TestDataSource.outputDirectory ]
        let task = ExtractLocStringsTask()
        return task.launch(argumets)
    }
    
    static func pathForTestDataResource(_ resource: String, ofType type: String) -> String? {
        let bundle = Bundle(for: self)
        
        return bundle.path(forResource: resource,
                           ofType: type,
                           inDirectory: testDataDirectory)
    }
    
}
