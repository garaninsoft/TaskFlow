//
//  PeriodNavigationButtons.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct PeriodNavigationButtons: View {
    @Binding var selectedDate: Date
    @Binding var calendarMode: CalendarMode
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                withAnimation {
                    switch calendarMode {
//                    case .day:
//                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }
            
            Text(periodTitle)
                .font(.headline)
                .frame(minWidth: 200)
            
            Button {
                withAnimation {
                    switch calendarMode {
//                    case .day:
//                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    case .week:
                        selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
                    case .month:
                        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
            }
        }
    }
    
    private var periodTitle: String {
        let formatter = DateFormatter()
        switch calendarMode {
//        case .day:
//            formatter.dateFormat = "d MMMM yyyy"
//            return formatter.string(from: selectedDate)
        case .week:
            let weekFormatter = DateIntervalFormatter()
            weekFormatter.dateTemplate = "d MMM"
            let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate)!
            return weekFormatter.string(from: weekInterval.start, to: weekInterval.end)
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: selectedDate)
        }
    }
}
