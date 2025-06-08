//
//  MeetingStatus.swift
//  TaskFlow
//
//  Created by alexandergaranin on 08.06.2025.
//

import SwiftUI

enum ScheduleStatus {
    case invalid
    case planned
    case progress
    case finished
    case completed
    
    var color: Color {
        switch self {
        case .invalid:   return Color.gray.opacity(0.3)    // Невалидное (нет дат)
        case .planned:   return Color.blue.opacity(0.3)    // Запланировано
        case .progress: return Color.green.opacity(0.3)   // В процессе
        case .finished: return Color.orange.opacity(0.3)  // Завершено (без подтверждения)
        case .completed: return Color.purple.opacity(0.3) // Подтверждено
        }
    }
    
    var label: String {
        switch self {
        case .invalid: return "Не определено"
        case .planned: return "Запланировано"
        case .progress: return "В процессе"
        case .finished: return "Завершено"
        case .completed: return "Подтверждено"
        }
    }
}
