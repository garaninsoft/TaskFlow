//
//  FileSystemServiceProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 14.05.2025.
//

import Foundation

/// Интерфейс для работы с файловой системой (Domain Layer)
protocol FileSystemServiceProtocol {
    func createFolderIfNeeded(at path: String) throws
    func openFolderInFinder(at path: String) throws
}
