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
    private let backupFileExtension = ".backup"
    
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
        
        try backupStringsFiles(originalFiles)
    }
    
    func performMerge() throws {
        let stringsFiles = findFiles(with: stringsFileExtension)
        
        for file in stringsFiles {
            let filePath = outputDirectory.appending("/\(file)")
            let backupFilePath = filePath.appending(backupFileExtension)
            try mergeFile(atPath: filePath, withBackupPath: backupFilePath)
        }
        
        try completeMerge()
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
    
    private func backupStringsFiles(_ files: [String]) throws {
        for file in files {
            let filePath = outputDirectory.appending("/\(file)")
            let backupPath = filePath.appending(backupFileExtension)
            try FileManager.default.moveItem(atPath: filePath, toPath: backupPath)
        }
    }
    
    private func moveUnusedBackupFiles(_ files: [String]) throws {
        for backupFile in files {
            let fileName = backupFile.replacingOccurrences(of: backupFileExtension, with: "")
            try FileManager.default.moveItem(atPath: outputDirectory.appending("/\(backupFile)"),
                                             toPath: outputDirectory.appending("/\(fileName)"))
        }
    }
    
    // MARK: Merge
    
    private func mergeFile(atPath path: String, withBackupPath backupPath: String) throws {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path), fileManager.fileExists(atPath: backupPath) else {
            return
        }
        
        let localizedStrings = try StringsFileParser.parse(contentOf: path)
        let backupStrings = try StringsFileParser.parse(contentOf: backupPath)
        var resultStrings: [LocalizedString] = []
        
        for string in localizedStrings {
            let updatedString = updateStringIfNeeded(string, with: backupStrings)
            resultStrings.append(updatedString)
        }
        
        try serializeStrings(resultStrings, to: path)
        try fileManager.removeItem(atPath: backupPath)
    }
    
    private func updateStringIfNeeded(_ string: LocalizedString, with backupStrings: [LocalizedString]) -> LocalizedString {
        if let existString = findLocalizedString(with: string.key, in: backupStrings) {
            let updatedString = LocalizedString(comment: string.comment, key: string.key, value: existString.value)
            return updatedString
        }
        
        return string
    }
    
    private func findLocalizedString(with key: String, in strings: [LocalizedString]) -> LocalizedString? {
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
        
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
    }
    
    private func completeMerge() throws {
        let backupFiles = findFiles(with: backupFileExtension)
        
        guard backupFiles.count > 0 else {
            return
        }
        
        try moveUnusedBackupFiles(backupFiles)
    }
    
}
