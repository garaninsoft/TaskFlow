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

// Enum с вариантами форматов
enum DateFormat: String {
    case defaultFormat = "dd.MM.yyyy_HH-mm-ss"
    case shortDate = "dd.MM.yy"
//    case longDate = "EEEE, d MMM yyyy"
//    case timeOnly = "HH:mm:ss"
    // добавляй свои форматы по необходимости
}

extension Date {
    
    func formatted(_ format: DateFormat = .defaultFormat) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            formatter.locale = Locale.current
            return formatter.string(from: self)
        }
//    
//    var localFormatted: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.yyyy_HH-mm-ss"
//        formatter.locale = Locale.current
//        return formatter.string(from: self)
//    }
    
    func adding(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension String {
    func generateShortNameWithTranslit() -> String {
        // Быстрый транслит
        let latin = self.lowercased()
            .replacingOccurrences(of: "а", with: "a")
            .replacingOccurrences(of: "б", with: "b")
            .replacingOccurrences(of: "в", with: "v")
            .replacingOccurrences(of: "г", with: "g")
            .replacingOccurrences(of: "д", with: "d")
            .replacingOccurrences(of: "е", with: "e")
            .replacingOccurrences(of: "ё", with: "e")
            .replacingOccurrences(of: "ж", with: "zh")
            .replacingOccurrences(of: "з", with: "z")
            .replacingOccurrences(of: "и", with: "i")
            .replacingOccurrences(of: "й", with: "y")
            .replacingOccurrences(of: "к", with: "k")
            .replacingOccurrences(of: "л", with: "l")
            .replacingOccurrences(of: "м", with: "m")
            .replacingOccurrences(of: "н", with: "n")
            .replacingOccurrences(of: "о", with: "o")
            .replacingOccurrences(of: "п", with: "p")
            .replacingOccurrences(of: "р", with: "r")
            .replacingOccurrences(of: "с", with: "s")
            .replacingOccurrences(of: "т", with: "t")
            .replacingOccurrences(of: "у", with: "u")
            .replacingOccurrences(of: "ф", with: "f")
            .replacingOccurrences(of: "х", with: "h")
            .replacingOccurrences(of: "ц", with: "c")
            .replacingOccurrences(of: "ч", with: "ch")
            .replacingOccurrences(of: "ш", with: "sh")
            .replacingOccurrences(of: "щ", with: "sh")
            .replacingOccurrences(of: "ы", with: "y")
            .replacingOccurrences(of: "э", with: "e")
            .replacingOccurrences(of: "ю", with: "yu")
            .replacingOccurrences(of: "я", with: "ya")
        
        // Формируем короткое имя
        var result = String(latin.prefix(2))
        if latin.count >= 5 { result += String(Array(latin)[4]) }
        if latin.count >= 7 { result += String(Array(latin)[6]) }
        
        return result
    }
    
    func abbreviateText() -> String {
        let cons = Set("бвгджзйклмнпрстфхцчшщ")
        return self.split(separator: " ").map { word in
            let w = String(word)
            if w.count<=3 { return w }
            if w.contains(where: { $0.isASCII && $0.isLetter }) { return w }
            let chars = Array(w)
            var r = [chars[0]]
            for c in chars.dropFirst() where cons.contains(c.lowercased().first!) && r.count < 3 {
                r.append(c)
            }
            return String(r)
        }.joined(separator: "_")
    }
}
