//
//  AppSettings.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.07.2025.
//

import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage("rootOrdersPath") var rootOrdersPath = ""
    @AppStorage("dbPath") var dbPath = ""
    @AppStorage("dbName") var dbName = Constants.bdNameDefault
    @AppStorage("dbBackupPath") var dbBackupPath = ""
    @AppStorage("dbBackupName") var dbBackupName = Constants.bdNameDefault
    
    private init() {} // Синглтон
    
    func reset() {
        rootOrdersPath = ""
        dbPath = ""
        dbName = Constants.bdNameDefault
        dbBackupPath = ""
        dbBackupName = Constants.bdNameDefault
    }
    
    var isConfigured: Bool {
        !rootOrdersPath.isEmpty &&
        !dbPath.isEmpty &&
        !dbName.isEmpty &&
        !dbBackupPath.isEmpty &&
        !dbBackupName.isEmpty
    }
}
