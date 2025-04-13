//
//  Order+Formatting.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

import Foundation

protocol TimeDiscrepancyFormattable {
    var totalTimeDiscrepancyInMinutes: Int { get }
}

extension TimeDiscrepancyFormattable {
    var formattedTotalTimeDiscrepancy: String {
        let totalMinutes = abs(totalTimeDiscrepancyInMinutes)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        let sign = totalTimeDiscrepancyInMinutes > 0 ? "+" : "-"
        let strHours = hours > 0 ? "\(hours) ч ":""
        return hours == 0 && minutes == 0 ? "--:--" : "\(sign)\(strHours)\(minutes) мин"
    }
}

// Теперь можно применить к Order и Students
extension Order: TimeDiscrepancyFormattable {}
extension Student: TimeDiscrepancyFormattable {}

extension Double {
    func formattedAsCurrency(currencySymbol: String = "₽",
                             fractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        formatter.maximumFractionDigits = fractionDigits
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

extension TimeInterval {
    func formatDuration() -> String {
        let totalSeconds = Int(self)
        guard totalSeconds > 0 else { return "0 мин" }
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        switch (hours, minutes) {
        case (0, _):
            return "\(minutes) мин"
        case (_, 0):
            return "\(hours) ч"
        default:
            return "\(hours) ч \(minutes) мин"
        }
    }
}
