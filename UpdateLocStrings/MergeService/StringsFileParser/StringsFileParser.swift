//
//  StringsFileParser.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 08/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

final class StringsFileParser {
    
    // MARK: - Public methods
    
    static func parse(contentOf filePath: String) throws -> [LocalizedString] {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: filePath) else {
            return []
        }
        
        // TODO: Add support for strings without comment and strings with multiple comments
        let content = try String(contentsOfFile: filePath, encoding: .utf16)
        let commentPattern = "/\\* (.*) \\*/"
        let keyValuePattern = "\"(.*)\""
        let pattern = "\(commentPattern)\n\(keyValuePattern) = \(keyValuePattern);"
        
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let result = regex.matches(in: content,
                                   options: [],
                                   range: NSRange(location: 0, length: content.characters.count))
        
        var strings: [LocalizedString] = []
        
        for match in result {
            if let string = localizedString(from: match, in: content) {
                strings.append(string)
            }
        }
        
        return strings
    }
    
    // MARK: - Private methods
    
    private static func localizedString(from match: NSTextCheckingResult, in text: String) -> LocalizedString? {
        guard let commentRange = text.range(from: match.rangeAt(1)),
            let keyRange = text.range(from: match.rangeAt(2)),
            let valueRange = text.range(from: match.rangeAt(3)) else {
                return nil
        }
        
        let comment = text.substring(with: commentRange)
        let key = text.substring(with: keyRange)
        let value = text.substring(with: valueRange)
        
        return LocalizedString(comment: comment, key: key, value: value)
    }

}

fileprivate extension String {
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex,
                                     offsetBy: nsRange.location,
                                     limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex,
                                   offsetBy: nsRange.location + nsRange.length,
                                   limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else {
                return nil
        }
        return from ..< to
    }
    
}
