//
//  LocalizedString.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 08/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

struct LocalizedString: CustomStringConvertible {
    
    let comment: String
    let key: String
    let value: String
    
    var description: String {
        return "/* \(comment) */\n\"\(key)\" = \"\(value)\";"
    }
    
}
