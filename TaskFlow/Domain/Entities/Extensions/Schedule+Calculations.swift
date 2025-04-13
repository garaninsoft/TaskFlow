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
    
    static func calculateFinishMeeting(startDate: Date?, totalPayment: Double, hourlyRate: Double) -> Date? {
        // Рассчитываем количество оплаченных минут
        if totalPayment == 0 || hourlyRate == 0{
            return nil
        }
        if let start = startDate{
            let paidHours = totalPayment / hourlyRate
            let paidMinutes = paidHours * 60
            
            // Округляем до целых минут (если нужно)
            let roundedMinutes = Int(paidMinutes.rounded())
            
            // Добавляем минуты к дате начала
            return Calendar.current.date(byAdding: .minute, value: roundedMinutes, to: start)
        }
        
        return nil
    }
}
