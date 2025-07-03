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
    @AppStorage("bdPath") var bdPath = ""
    @AppStorage("bdName") var bdName = "tflowbd.sqlite"
    @AppStorage("bdBackupPath") var bdBackupPath = ""
    @AppStorage("bdBackupName") var bdBackupName = ""
    
    private init() {} // Синглтон
}
