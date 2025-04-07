//
//  Schedule+Сфдсгдфешщты.swift
//  TaskFlow
//
//  Created by alexandergaranin on 06.04.2025.
//

import Foundation
import SwiftData

extension Schedule {
    // Возвращает первое найденное конфликтующее событие
//    static func findTimeConflict(
//        withStart start: Date,
//        finish: Date,
//        excluding scheduleID: Schedule.ID? = nil,
//        in modelContext: ModelContext
//    ) -> Schedule? {
//        let predicate = #Predicate<Schedule> { existing in
//            (existing.start != nil && existing.finish != nil) &&
//            (existing.id != scheduleID) &&
//            (
//                (start >= existing.start! && start < existing.finish!) ||
//                (finish > existing.start! && finish <= existing.finish!) ||
//                (start <= existing.start! && finish >= existing.finish!)
//            )
//        }
//        
//        do {
//            let conflicts = try modelContext.fetch(FetchDescriptor<Schedule>(predicate: predicate))
//            return conflicts.first
//        } catch {
//            print("Ошибка при проверке конфликтов: \(error)")
//            return nil
//        }
//    }
}
