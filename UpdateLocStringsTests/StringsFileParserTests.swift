//
//  StringsFileParserTests.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 08/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import XCTest

class StringsFileParserTests: XCTestCase {

    func testParse() {
        let path = TestDataSource.pathForTestDataResource(TestDataSource.stringsResource,
                                                          ofType: TestDataSource.stringsType)
        guard let stringsFilePath = path else {
            XCTFail()
            return
        }
        
        let localizedStrings: [LocalizedString]
        
        do {
            localizedStrings = try StringsFileParser.parse(contentOf: stringsFilePath)
        }
        catch {
            localizedStrings = []
            XCTFail()
        }
        
        XCTAssertTrue(localizedStrings.count > 0)
        
        let firstString = localizedStrings.first!
        XCTAssertTrue(firstString.comment == "Comment for first string")
        XCTAssertTrue(firstString.key == "testString.1")
        XCTAssertTrue(firstString.value == "first string")
    }

}
