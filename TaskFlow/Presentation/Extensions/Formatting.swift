//
//  Order+Formatting.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

protocol TimeDiscrepancyFormattable {
    var totalTimeDiscrepancyInMinutes: Int { get }
}

extension TimeDiscrepancyFormattable {
    var formattedTotalTimeDiscrepancy: String {
        let totalMinutes = abs(totalTimeDiscrepancyInMinutes)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = totalTimeDiscrepancyInMinutes >= 0 ? "+" : "-"
        
        return "\(sign)\(hours)ч \(minutes)мин"
    }
}

// Теперь можно применить к Order и Students
extension Order: TimeDiscrepancyFormattable {}
extension Student: TimeDiscrepancyFormattable {}
