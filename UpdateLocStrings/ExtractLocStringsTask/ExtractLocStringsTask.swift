//
//  GenstringsTask.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 27/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

final public class ExtractLocStringsTask {
    
    // MARK: - Public methods
    
    @discardableResult
    func launch(_ args: [String]?) -> Int32 {
        let task = Process()
        
        guard let launchPath = findLaunchPath() else {
            print("\(type(of: self)): xcrun not found")
            return -1
        }
        task.launchPath = launchPath
        
        var arguments = ["extractLocStrings"]
        if let inputArgs = args {
            arguments.append(contentsOf: inputArgs)
        }
        task.arguments = arguments
        
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    // MARK: - Private methods
    
    func findLaunchPath() -> String? {
        let task = Process()
        task.launchPath = "/usr/bin/whereis"
        task.arguments = ["xcrun"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let taskOutput = String(data: data, encoding: .utf8)
        let path = taskOutput?.replacingOccurrences(of: "\n", with: "")
        return path
    }
    
}
