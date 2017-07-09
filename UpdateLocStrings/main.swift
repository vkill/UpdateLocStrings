//
//  main.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 04/07/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation


func parseRawArguments(_ args: [String]) -> Arguments {
    let arguments = ArgumentsParser.parse(args)
    return arguments
}

func createMergeService(with arguments: Arguments) -> MergeService? {
    if let output = arguments.outputDirectory, arguments.merge {
        return MergeService(outputDirectory: output)
    }
    
    return nil
}

func prepareForMergeIfNeeded(with service: MergeService?) {
    guard let mergeService = service else {
        return
    }
    
    do {
        try mergeService.prepareForMerge()
    }
    catch {
        print(error)
        return
    }
}

func performMergeIfNeeded(with service: MergeService?) {
    guard let mergeService = service else {
        return
    }
    
    do {
        try mergeService.performMerge()
        try mergeService.completeMerge()
    }
    catch {
        print(error)
    }
}

func launchExtractLocStringsTask(with rawArguments: [String]) {
    let task = ExtractLocStringsTask()
    // Should remove first argument with path of executable file (UpdateLocStrings)
    let launchArguments = Array(rawArguments.dropFirst())
    if launchArguments.count == 0 {
        printUsageHelp()
    }
    task.launch(launchArguments)
}

func printUsageHelp() {
    print("Usage: updateLocStrings [OPTION] [extractLocStrings OPTION] file1.[mc] ... filen.[mc]\n")
    print("Options")
    print(" -m\tmerge generated files with previous version\n")
}

func main() {
    let rawArguments = CommandLine.arguments
    let arguments = parseRawArguments(rawArguments)
    let mergeService = createMergeService(with: arguments)
    
    prepareForMergeIfNeeded(with: mergeService)
    launchExtractLocStringsTask(with: rawArguments)
    performMergeIfNeeded(with: mergeService)
}

main()
