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
        let firstString = NSLocalizedString("TestSwiftClass.firstString", "Localized string with key and comment only")
        let secondString = NSLocalizedString("TestSwiftClass.secondString", tableName: "TestSwiftClass", comment: "Localized string from custom table")
        let thirdString = NSLocalizedString("TestSwiftClass.thirdString", tableName: "Localizable", bundle: Bundle.main, value: "default value", comment: "Localized string with default value")
        
        print("firstString: \(firstString)\nsecondString: \(secondString)\nthirdString: \(thirdString)")
    }
    
}
