//
//  DateTimeFormatText.swift
//  TaskFlow
//
//  Created by alexandergaranin on 21.03.2025.
//

import SwiftUI

struct DateTimeFormatText: View {
    
    let date: Date?
    let width: CGFloat = 120
    var style: Style = .meeting
    
    enum Style: Equatable {
        case meeting      // "Пн 15-05/n14:30"
        case short       // "15 мая 14:30"
        case verbose     // "Понедельник, 15 мая 2023"
        case timeOnly    // "14:30"
        
        private static let ruLocale = Locale(identifier: "ru_RU")
           private static let mainFormatter: DateFormatter = {
               let formatter = DateFormatter()
               formatter.locale = ruLocale
               return formatter
           }()
           private static let secondFormatter: DateFormatter = {
               let formatter = DateFormatter()
               formatter.locale = ruLocale
               return formatter
           }()
        
        var formatter: (main: DateFormatter, second: DateFormatter) {
            let main = Self.mainFormatter
            let second = Self.secondFormatter
            switch self {
            case .meeting:
                main.dateFormat = "EEE dd MMM yy"
                second.dateStyle = .none
                second.timeStyle = .short
            case .short:
                main.dateStyle = .short
                main.timeStyle = .short
            case .verbose:
                main.dateStyle = .full
                main.timeStyle = .none
            case .timeOnly:
                main.dateStyle = .none
                main.timeStyle = .short
            }
            return (main, second)
        }
    }
    
    var body: some View {
        Group {
            if let date = date {
                if style == .meeting{
                    VStack(alignment: .leading) {
                        Text(style.formatter.main.string(from: date))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(style.formatter.second.string(from: date))
                            .font(.headline)
                    }
                    .padding(4)
                }else{
                    Text(style.formatter.main.string(from: date))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .monospacedDigit()
                        .padding(4)
                }
            } else {
                Text("--:--")
                    .foregroundColor(.red)
                    .padding(4)
            }
        }
        .frame(width: width)
    }
}

#Preview{
    VStack(spacing: 0){
        Group{
            DateTimeFormatText(date: Date())
                .border(Color.gray)
        }
        .padding()
        
        Group{
            DateTimeFormatText(date: nil)
                .border(Color.gray)
        }
        .padding()
        
        Group{
            DateTimeFormatText(date: Date(), style: .short)
                .border(Color.gray)
        }
        .padding()
        
        Group{
            DateTimeFormatText(date: Date(), style: .timeOnly)
                .border(Color.gray)
        }
        .padding()
        
        Group{
            DateTimeFormatText(date: Date(), style: .verbose)
                .border(Color.gray)
        }
        .padding()
    }
    .padding()
    
}
