//
//  MergeService.swift
//  UpdateLocStrings
//
//  Created by Anton Grachev on 27/06/2017.
//  Copyright © 2017 Anton Grachev. All rights reserved.
//

import Foundation

final public class MergeService {
    
    // MARK: - Private properties
    
    private let outputDirectory: String
    private let stringsFileExtension = ".strings"
    private let mergeFileExtension = ".merge_old"
    
    // MARK: - Init
    
    init(outputDirectory: String) {
        self.outputDirectory = outputDirectory
    }
    
    // MARK: - Public methods
    
    func prepareForMerge() throws {
        let originalFiles = findFiles(with: stringsFileExtension)
        
        guard originalFiles.count > 0 else {
            return
        }
        
        try moveStringsFilesForMerge(originalFiles)
    }
    
    func performMerge() throws {
        let stringsFiles = findFiles(with: stringsFileExtension)
        
        for file in stringsFiles {
            let newFile = outputDirectory.appending("/\(file)")
            let oldFile = newFile.appending(mergeFileExtension)
            try merge(oldFile, to: newFile)
        }
    }
    
    func completeMerge() throws {
        let mergeFiles = findFiles(with: mergeFileExtension)
        
        guard mergeFiles.count > 0 else {
            return
        }
        
        try removeMergeFiles(mergeFiles)
    }
    
    // MARK: - Private methods
    
    // MARK: Work with files
    
    private func findFiles(with fileExtension: String) -> [String] {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: outputDirectory)
            return files.filter { $0.hasSuffix(fileExtension) }
        }
        catch {
            print("\(type(of: self)): \(error)")
            return []
        }
    }
    
    private func moveStringsFilesForMerge(_ files: [String]) throws {
        for file in files {
            let source = outputDirectory.appending("/\(file)")
            let destination = source.appending(mergeFileExtension)
            try FileManager.default.moveItem(atPath: source, toPath: destination)
        }
    }
    
    private func removeMergeFiles(_ files: [String]) throws {
        for file in files {
            try FileManager.default.removeItem(atPath: outputDirectory.appending("/\(file)"))
        }
    }
    
    // MARK: Merge
    
    private func merge(_ sourcePath: String, to destinationPath: String) throws {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: sourcePath), fileManager.fileExists(atPath: destinationPath) else {
            return
        }
        
        let sourceStrings = try StringsFileParser.parse(contentOf: sourcePath)
        let destinationStrings = try StringsFileParser.parse(contentOf: destinationPath)
        var resultStrings: [LocalizedString] = []
        
        for string in destinationStrings {
            let updatedString = updateStringIfNeeded(string, with: sourceStrings)
            resultStrings.append(updatedString)
        }
        
        try serializeStrings(resultStrings, to: destinationPath)
    }
    
    private func updateStringIfNeeded(_ string: LocalizedString, with existStrings: [LocalizedString]) -> LocalizedString {
        if let existString = localizedString(with: string.key, in: existStrings) {
            let updatedString = LocalizedString(comment: string.comment, key: string.key, value: existString.value)
            return updatedString
        }
        
        return string
    }
    
    private func localizedString(with key: String, in strings: [LocalizedString]) -> LocalizedString? {
        for string in strings {
            if string.key == key {
                return string
            }
        }
        
        return nil
    }
    
    private func serializeStrings(_ strings: [LocalizedString], to filePath: String) throws {
        var content = ""
        
        strings.forEach {
            content.append($0.description)
            content.append("\n\n")
        }
        
        try content.write(toFile: filePath, atomically: true, encoding: .utf16)
    }
    
}
