//
//  FileSystemService.swift
//  TaskFlow
//
//  Created by alexandergaranin on 14.05.2025.
//

import Foundation
import AppKit

/// Реализация файлового сервиса (Data Layer)
final class FileSystemService: FileSystemServiceProtocol {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func createFolderIfNeeded(at path: String) throws {
        guard !fileManager.fileExists(atPath: path) else { return }
        try fileManager.createDirectory(
            atPath: path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
    
    func openFolderInFinder(at path: String) throws {
        guard fileManager.fileExists(atPath: path) else {
            throw NSError(domain: "Folder does not exist", code: 404)
        }
        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: path)
    }
}
