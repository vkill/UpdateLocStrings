//
//  ArgumentsParser.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 28/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation


struct ArgumentsImpl: Arguments {
    
    let outputDirectory: String?
    let merge: Bool
    
}


final public class ArgumentsParser {
    
    // MARK: - Public static methods
    
    static func parse(_ arguments: [String]) -> Arguments {
        // Check if any arguments except launch path exists
        guard arguments.count > 1 else {
            return ArgumentsImpl(outputDirectory: nil, merge: false)
        }
        
        let output = outputDirectory(from: arguments)
        let merge = mergeOption(from: arguments)
        
        return ArgumentsImpl(outputDirectory: output, merge: merge)
    }
    
    // MARK: - Private static methods
    
    private static func outputDirectory(from arguments: [String]) -> String {
        let result: String
        
        let rawValue: String
        if let optionIndex = arguments.index(where: { $0.hasPrefix("-o") }) {
            rawValue = arguments[optionIndex.advanced(by: 1)]
        }
        else {
            rawValue = FileManager.default.currentDirectoryPath
        }
        
        result = NSString(string: rawValue).expandingTildeInPath
        return result
    }
    
    private static func mergeOption(from arguments: [String]) -> Bool {
        return arguments.contains("-m")
    }
    
}
