//
//  DateTimeFormatText.swift
//  TaskFlow
//
//  Created by alexandergaranin on 21.03.2025.
//

import SwiftUI

struct DateTimeFormatText: View {
    
    let date: Date?
    var style: Style = .compact
    var alignment: Alignment = .leading
    
    enum Style {
        case compact      // "Пн 15-05 [14:30]"
        case short       // "15 мая 14:30"
        case verbose     // "Понедельник, 15 мая 2023"
        case timeOnly    // "14:30"
        case custom(String)
        
        var formatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            
            switch self {
            case .compact:
                formatter.dateFormat = "EEE dd-MM [HH:mm]"
            case .short:
                formatter.dateStyle = .short
                formatter.timeStyle = .short
            case .verbose:
                formatter.dateStyle = .full
                formatter.timeStyle = .none
            case .timeOnly:
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            case .custom(let format):
                formatter.dateFormat = format
            }
            return formatter
        }
    }
    
    var body: some View {
        Group {
            if let date = date {
                Text(style.formatter.string(from: date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            } else {
                Text("--:--")
                    .foregroundColor(.gray.opacity(0.6))
            }
        }
        .frame(width: idealWidth, alignment: alignment)
    }
    
    private var idealWidth: CGFloat? {
        switch style {
        case .compact: return 120
        case .short: return 150
        case .verbose: return 200
        case .timeOnly: return 80
        case .custom: return nil
        }
    }
}
