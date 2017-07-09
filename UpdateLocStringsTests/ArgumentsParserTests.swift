//
//  ArgumentsParserTests.swift
//  genstringsmerge
//
//  Created by Anton Grachev on 28/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import XCTest

class ArgumentsParserTests: XCTestCase {

    func testParse() {
        let rawArguments = [ "UpdateLocStrings", "-o", "~/Documents", "-m" ]
        let arguments = ArgumentsParser.parse(rawArguments)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        guard let documentsDirectoryPath = path else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(arguments.outputDirectory == documentsDirectoryPath)
        XCTAssertTrue(arguments.merge == true)
    }
    
    func testParseWithoutArguments() {
        let rawArguments = [ "UpdateLocStrings" ]
        let arguments = ArgumentsParser.parse(rawArguments)
        
        XCTAssertTrue(arguments.outputDirectory == nil)
        XCTAssertTrue(arguments.merge == false)
    }
    
    func testParseWithoutOutputDirectory() {
        let rawArguments = [ "UpdateLocStrings", "-m" ]
        let arguments = ArgumentsParser.parse(rawArguments)
        
        XCTAssertTrue(arguments.outputDirectory == FileManager.default.currentDirectoryPath)
        XCTAssertTrue(arguments.merge == true)
    }
    
}
