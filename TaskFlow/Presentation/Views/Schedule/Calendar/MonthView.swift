//
//  MonthView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct MonthView: View {
    @Binding var selectedDate: Date
    
    private var weeks: [[Date]] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        // Получаем первый день месяца и корректируем на начало недели
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let firstWeekdayOffset = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        var weeks: [[Date]] = []
        var currentDate: Date
        
        // Начинаем с первого дня недели, содержащего начало месяца
        if let adjustedStart = calendar.date(byAdding: .day, value: -firstWeekdayOffset, to: firstDayOfMonth) {
            currentDate = adjustedStart
        } else {
            currentDate = firstDayOfMonth
        }
        
        // Генерируем 6 недель (максимально возможное количество в месяце)
        for _ in 0..<6 {
            var week: [Date] = []
            for _ in 0..<7 {
                week.append(currentDate)
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            }
            weeks.append(week)
            
            // Прекращаем если вышли за пределы месяца
            if currentDate > monthInterval.end {
                break
            }
        }
        
        return weeks
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовки дней недели с учетом первого дня недели системы
            ZeroSpacingHStack {
                ForEach(getOrderedWeekdaySymbols(), id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 8)
            
            // Сетка календаря
            VStack(spacing: 8) {
                ForEach(weeks, id: \.self) { week in
                    ZeroSpacingHStack {
                        ForEach(week, id: \.self) { date in
                            DayCell(date: date,
                                   isSelected: isSameDay(date, selectedDate),
                                   isCurrentMonth: isCurrentMonth(date))
                                .onTapGesture {
                                    withAnimation {
                                        selectedDate = date
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
    
    private func getOrderedWeekdaySymbols() -> [String] {
        let calendar = Calendar.current
        let firstWeekday = calendar.firstWeekday
        let symbols = calendar.shortWeekdaySymbols
        
        // Корректное формирование массива дней недели
        return Array(symbols[(firstWeekday-1)...]) + symbols[..<(firstWeekday-1)]
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month)
    }
}

//#Preview {
//    @Previewable @State var selectedDate: Date = Date()
//    MonthView(selectedDate: $selectedDate)
//}
