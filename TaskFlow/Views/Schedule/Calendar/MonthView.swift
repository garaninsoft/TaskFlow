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
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let firstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start) else {
            return []
        }
        
        var weeks: [[Date]] = []
        var currentWeekStart = firstWeek.start
        
        while currentWeekStart < monthInterval.end {
            var week: [Date] = []
            for dayOffset in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: dayOffset, to: currentWeekStart) {
                    week.append(date)
                }
            }
            weeks.append(week)
            currentWeekStart = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart)!
        }
        
        return weeks
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовки дней недели
            HStack(spacing: 0) {
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { day in
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
                    HStack(spacing: 0) {
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
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func isCurrentMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month)
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    MonthView(selectedDate: $selectedDate)
}
