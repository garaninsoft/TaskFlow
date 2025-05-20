//
//  BackupRepositoryProtocol.swift
//  TaskFlow
//
//  Created by alexandergaranin on 20.05.2025.
//

import Foundation

protocol BackupRepositoryProtocol {
    func createBackup() throws -> URL
}

