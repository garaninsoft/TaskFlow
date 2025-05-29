//
//  WeekView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct WeekView: View {
    @Binding var selectedDate: Date
    let meetings: [[Schedule]]
    
    private var weekDates: [Date] {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
            return []
        }
        
        var dates: [Date] = []
        for i in 0..<7 {
            if let date = Calendar.current.date(byAdding: .day, value: i, to: weekInterval.start) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовки дней недели
            ZeroSpacingHStack {
                // Заглушка для выравнивания
                Text("")
                    .foregroundColor(.secondary)
                    .frame(
                        width: CalendarConstants.widthColumnWithHour,
                        height: CalendarConstants.heighColumnWithWeekDays
                    )
                
                ForEach(weekDates, id: \.self) { date in
                    DayHeader(date: date, isSelected: isSameDay(date, selectedDate))
                        .onTapGesture {
                            withAnimation {
                                selectedDate = date
                            }
                        }
                }
            }
            
            // Сетка календаря
            ScrollView {
                ZeroSpacingHStack {
                    // Колонка с часами
                    VStack(spacing: 0) {
                        ForEach(0..<24) { hour in
                            Text(String(format: "%02d:00", hour))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(height: CalendarConstants.heighRowWeekView)
                        }
                    }
                    .frame(width: CalendarConstants.widthColumnWithHour)
                    
                    // Колонки дней
                    ForEach(Array(zip(weekDates.indices, weekDates)), id: \.1) { index, date in
                        DayColumn(date: date, isSelected: isSameDay(date, selectedDate), busyMinutes: convertSchedulesToBusyMinutes(meetings[index]))
                    }
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
    
    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    private func convertSchedulesToBusyMinutes(_ schedules: [Schedule]) -> [BusyMinute] {
        
        return schedules.compactMap { schedule in
            guard let start = schedule.start,
                  let finish = schedule.finish,
                  let student = schedule.order?.student else {
                return nil
            }
            
            let calendar = Calendar.current
            let startMinute = calendar.component(.hour, from: start) * 60 + calendar.component(.minute, from: start)
            let endMinute = calendar.component(.hour, from: finish) * 60 + calendar.component(.minute, from: finish)
            
            return BusyMinute(
                student: student,
                startMinute: startMinute,
                endMinute: endMinute
            )
        }
    }
}

//#Preview {
//    @Previewable @State var selectedDate: Date = Date()
//    WeekView(selectedDate: $selectedDate)
//}
