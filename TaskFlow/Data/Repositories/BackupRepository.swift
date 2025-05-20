//
//  Untitled.swift
//  TaskFlow
//
//  Created by alexandergaranin on 20.05.2025.
//

import Foundation

final class BackupRepository: BackupRepositoryProtocol {
    func createBackup() throws -> URL {
        try SQLiteBackupManager.createBackup()
    }
}
