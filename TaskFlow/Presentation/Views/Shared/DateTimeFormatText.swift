//
//  DateTimeFormatText.swift
//  TaskFlow
//
//  Created by alexandergaranin on 21.03.2025.
//

import SwiftUI

enum EDateFormatter{
    case format1
    case format2
    
    func getFormat() -> String {
        switch self {
        case .format1:
            return "EEE dd-MM [HH:mm]"
        case .format2:
            return "dd-MM [HH:mm]"
        }
    }
}

struct DateTimeFormatText: View {
    
    let date: Date?
    @State private var dateFormatter: DateFormatter
    
    init(date: Date?, format: EDateFormatter) {
        self.date = date

        self.dateFormatter = { // Создаем DateFormatter только один раз
            let formatter = DateFormatter()
        formatter.dateFormat = format.getFormat()  // Пример формата
        formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    }
    
    var body: some View {
        Text(date != nil ? dateFormatter.string(from: date!) : "")
            .frame(width: 150, alignment: .leading)
            .padding(.horizontal, 8)
    }
}
