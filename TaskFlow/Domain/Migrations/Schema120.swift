//
//  PersonMigrations.swift
//  TaskFlow
//
//  Created by alexandergaranin on 16.04.2025.
//

import SwiftData
import Foundation

//// MARK: - Версия 1.2.0
enum Schema120: VersionedSchema {
    static var models: [any PersistentModel.Type] = [
        Payment.self
    ]
    static var versionIdentifier: Schema.Version = .init(1, 2, 0)
}


