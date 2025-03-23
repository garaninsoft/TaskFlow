//
//  CalendarView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate: Date = Date()
        @State private var selectedDate: Date? = nil

        private let calendar = Calendar.current
        private let dateFormatter = DateFormatter()

        init() {
            dateFormatter.dateFormat = "MMMM yyyy"
        }

        private var monthTitle: String {
            return dateFormatter.string(from: currentDate)
        }

        private var daysInMonth: Int {
            let range = calendar.range(of: .day, in: .month, for: currentDate)!
            return range.count
        }

        private var firstDayOfMonth: Date {
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            return calendar.date(from: components)!
        }

        private var firstDayOfWeek: Int {
            return calendar.component(.weekday, from: firstDayOfMonth) - 1 // 0 (Sunday) to 6 (Saturday)
        }
    
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.plain) // Убираем стандартное оформление кнопки на macOS

                    Spacer()
                    Text(monthTitle)
                        .font(.title)
                    Spacer()

                    Button(action: {
                        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .buttonStyle(.plain) // Убираем стандартное оформление кнопки на macOS
                }
                .padding()

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(0..<7, id: \.self) { dayOfWeek in
                        Text(shortWeekdayName(for: dayOfWeek))
                            .font(.caption)
                    }

                    ForEach(0..<firstDayOfWeek, id: \.self) { _ in
                        Text("") // Empty cells before the first day
                    }

                    ForEach(1...daysInMonth, id: \.self) { day in
                        let date = dateForDay(day: day)
                        Button(action: {
                            selectedDate = date
                        }) {
                            Text("\(day)")
                                .padding(5)
                                .background(isDateSelected(date) ? Color.blue : Color.clear)
                                .foregroundColor(isDateSelected(date) ? .white : .primary)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain) // Убираем стандартное оформление кнопки на macOS
                    }
                }
                .padding()

                if let selectedDate = selectedDate {
                    Text("Выбранная дата: \(selectedDate, formatter: dateFormatter)")
                        .padding()
                }
            }
//            .frame(width: 300, height: 300) // Фиксированный размер окна
        }

        private func shortWeekdayName(for dayOfWeek: Int) -> String {
            let weekdaySymbols = calendar.shortWeekdaySymbols
            return weekdaySymbols[dayOfWeek]
        }

        private func dateForDay(day: Int) -> Date {
            var components = calendar.dateComponents([.year, .month], from: currentDate)
            components.day = day
            return calendar.date(from: components)!
        }

        private func isDateSelected(_ date: Date) -> Bool {
            if let selectedDate = selectedDate {
                return calendar.isDate(date, inSameDayAs: selectedDate)
            }
            return false
        }
}

#Preview {
    CalendarView()
}
