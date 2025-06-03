//
//  DayView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayView: View {
    @Binding var selectedDate: Date
    let meetings: [Schedule]
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(0..<24) { hour in
                    let busyMinutes = busyMinutes(for: hour)
                    HourRow(
                        hour: hour,
                        busyMinutes: busyMinutes
                    )
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 1) // Толщина "spacing"
                }
            }
            .padding()
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .padding()
    }
    
    // Функция для определения занятых минут в конкретном часе
    private func busyMinutes(for hour: Int) -> [BusyMinute] {
        var result: [BusyMinute] = []
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let startOfHour = calendar.date(byAdding: .hour, value: hour, to: startOfDay)!
        let endOfHour = calendar.date(byAdding: .hour, value: hour + 1, to: startOfDay)!
        
        for meeting in meetings {
            guard
                let start = meeting.start,
                let finish = meeting.finish
            else { continue }
            
            // Проверяем, пересекается ли встреча с текущим часом
            if start < endOfHour && finish > startOfHour {
                let meetingStart = max(start, startOfHour)
                let meetingEnd = min(finish, endOfHour)
                
                let startComponents = calendar.dateComponents([.minute], from: startOfHour, to: meetingStart)
                let endComponents = calendar.dateComponents([.minute], from: startOfHour, to: meetingEnd)
                
                let startMinute = startComponents.minute ?? 0
                let endMinute = endComponents.minute ?? 60
                
                result.append(BusyMinute(
                    meeting: meeting,
                    startMinute: startMinute,
                    endMinute: endMinute
                ))
            }
        }
        
        return result.sorted { $0.startMinute < $1.startMinute }
    }
}

//#Preview {
//    @Previewable @State var selectedDate: Date = Date()
//    DayView(selectedDate: $selectedDate)
//}
