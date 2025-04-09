//
//  Schedule+Сфдсгдфешщты.swift
//  TaskFlow
//
//  Created by alexandergaranin on 06.04.2025.
//

import Foundation
import SwiftData

extension Schedule {
    static func findTimeConflict(
        withStart start: Date,
        finish: Date,
        buffer: TimeInterval = 0, // Буфер в секундах (по умолчанию 0)
        excluding scheduleID: Schedule.ID? = nil,
        in modelContext: ModelContext,
        fetchLimit: Int = 200
    ) -> Schedule? {
        do {
               let bufferedStart = start.addingTimeInterval(-buffer)
               let bufferedFinish = finish.addingTimeInterval(buffer)
               
               // Получаем все записи без сложного предиката
               var descriptor = FetchDescriptor<Schedule>(
                   sortBy: [SortDescriptor(\.start)]
               )
               descriptor.fetchLimit = fetchLimit
               
               let allSchedules = try modelContext.fetch(descriptor)
               
               // Фильтрация полностью в памяти
               return allSchedules.first { existing in
                   guard let existingStart = existing.start,
                         let existingFinish = existing.finish,
                         existing.id != scheduleID else {
                       return false
                   }
                   return bufferedStart < existingFinish && bufferedFinish > existingStart
               }
           } catch {
               print("Ошибка при проверке конфликтов: \(error)")
               return nil
           }
    }
}
