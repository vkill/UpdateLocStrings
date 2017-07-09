//
//  TestSwiftClass.swift
//  genstringsmerge
//
//  Created by Anton Grachev on 27/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

class TestSwiftClass {
    
    func methodWithLocalizedString() {
        let firstString = NSLocalizedString("TestSwiftClass.firstString",
                                            "Updated localized string with key and comment only")
        let secondString = NSLocalizedString("TestSwiftClass.secondString",
                                             tableName: "TestSwiftClass",
                                             comment: "Updated localized string from custom table")
        let thirdString = NSLocalizedString("TestSwiftClass.thirdString",
                                            tableName: "Localizable",
                                            bundle: Bundle.main,
                                            value: "Updated default value",
                                            comment: "Updated localized string with default value")
        let fourthString = NSLocalizedString("TestSwiftClass.fourthString",
                                             tableName: "TestSwiftClass",
                                             comment: "Updated localized string from custom table")
        let fifthString = NSLocalizedString("TestSwiftClass.fifthString",
                                            tableName: "Localizable",
                                            bundle: Bundle.main,
                                            value: "Updated default value",
                                            comment: "Updated localized string with default value")
        
        print("1: \(firstString)\ns2: \(secondString)\n3: \(thirdString)")
    }
    
}
