//
//  SQLiteBackupManager.swift
//  TaskFlow
//
//  Created by alexandergaranin on 20.05.2025.
//

import Foundation
import SQLite3

struct SQLiteBackupManager {
   static func createBackup() throws -> URL {
       
       let fileManager = FileManager.default
       
       let appSupportURL = URL(fileURLWithPath: AppSettings.shared.dbPath)
       
       // 1. Создаем папку для бэкапа с timestamp
       let backupDir = URL(fileURLWithPath: AppSettings.shared.dbBackupPath)
           .appendingPathComponent("backup_\(Date().formatted())")
       try fileManager.createDirectory(at: backupDir, withIntermediateDirectories: true)
       
       // 2. Основной файл БД
       let sourceDBPath = appSupportURL.appendingPathComponent(AppSettings.shared.dbName).path
       let backupDBPath = backupDir.appendingPathComponent(AppSettings.shared.dbBackupName).path
       
       // 3. Копируем через SQLite Backup API
       var sourceDB: OpaquePointer?
       var backupDB: OpaquePointer?
       
       // Открываем исходную БД
       guard sqlite3_open(sourceDBPath, &sourceDB) == SQLITE_OK else {
           throw NSError(domain: "SQLiteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось открыть исходную БД"])
       }
       
       // Открываем/создаем резервную БД
       guard sqlite3_open(backupDBPath, &backupDB) == SQLITE_OK else {
           sqlite3_close(sourceDB)
           throw NSError(domain: "SQLiteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать бэкап"])
       }
       
       // Настраиваем резервное копирование
       let backupHandle = sqlite3_backup_init(backupDB, "main", sourceDB, "main")
       guard backupHandle != nil else {
           sqlite3_close(sourceDB)
           sqlite3_close(backupDB)
           throw NSError(domain: "SQLiteError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Ошибка инициализации бэкапа"])
       }
       
       // Копируем данные
       sqlite3_backup_step(backupHandle, -1) // -1 = копируем всю БД
       sqlite3_backup_finish(backupHandle)
       
       // Закрываем соединения
       sqlite3_close(sourceDB)
       sqlite3_close(backupDB)
       
       // 4. Дополнительно копируем WAL и SHM файлы
       let sourceWAL = appSupportURL.appendingPathComponent("\(AppSettings.shared.dbName)-wal")
       let sourceSHM = appSupportURL.appendingPathComponent("\(AppSettings.shared.dbName)-shm")
       
       if fileManager.fileExists(atPath: sourceWAL.path) {
           try fileManager.copyItem(
               at: sourceWAL,
               to: backupDir.appendingPathComponent("\(AppSettings.shared.dbBackupName)-wal")
           )
       }
       
       if fileManager.fileExists(atPath: sourceSHM.path) {
           try fileManager.copyItem(
               at: sourceSHM,
               to: backupDir.appendingPathComponent("\(AppSettings.shared.dbBackupName)-shm")
           )
       }
       
       return backupDir
   }
}
