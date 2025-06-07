//
//  DayColumn.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayColumn: View {
    @ObservedObject var viewModel: MainViewModel
    
    let date: Date
    let isSelected: Bool
    let busyMinutes: [BusyMinute]
    
    var body: some View {
        ZStack(alignment: .top) {
            // Фоновые прямоугольники для каждого часа
            VStack(spacing: 0) {
                ForEach(0..<24) { _ in
                    Rectangle()
                        .fill(isSelected ? Color.red.opacity(0.05) : Color.gray.opacity(0.05))
                        .frame(height: CalendarConstants.heighRowWeekView)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.2)),
                            alignment: .bottom
                        )
                }
            }
            
            // Занятые промежутки поверх фона
            ForEach(busyMinutes.indices, id: \.self) { index in
                busyTimeView(for: busyMinutes[index])
            }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray.opacity(0.2), width: 0.5)
    }
    
    @ViewBuilder
       private func busyTimeView(for busyMinute: BusyMinute) -> some View {
           let startHour = busyMinute.startMinute / CalendarConstants.totalMinutesInHour
           let startMinuteInHour = busyMinute.startMinute % CalendarConstants.totalMinutesInHour
           
           let topOffset = CGFloat(startHour) * CalendarConstants.heighRowWeekView + (CGFloat(startMinuteInHour) / CGFloat(CalendarConstants.totalMinutesInHour)) * CalendarConstants.heighRowWeekView
           let height = CGFloat(busyMinute.endMinute - busyMinute.startMinute) / CGFloat(CalendarConstants.totalMinutesInHour) * CalendarConstants.heighRowWeekView
           
           Rectangle()
               .fill(Color.blue.opacity(0.3)) // Цвет занятого времени
               .frame(height: height)
               .overlay(
                Text(busyMinute.meeting.order?.student?.name ?? "")
                       .font(.caption)
                       .padding(2)
                       .background(Color.white.opacity(0.7))
                       .cornerRadius(2),
                   alignment: .topLeading
               )
               .overlay(
                   RoundedRectangle(cornerRadius: 2)
                       .stroke(Color.blue, lineWidth: 1)
               )
               .offset(y: topOffset)
               .contextMenu {
                   Button(action: {
                       viewModel.selectedMeeting = busyMinute.meeting
                       viewModel.showSheetEditMeeting = true
                   }) {
                       Label("Редактировать", systemImage: "pencil")
                   }
                   
                   Button(action: {
                       viewModel.selectedMeeting = busyMinute.meeting
                       viewModel.showSheetEditMeeting = true
                   }) {
                       Label("Закрыть", systemImage: "trash")
                   }
               }
       }
}

//#Preview {
//    DayColumn(date: Date(), isSelected: true)
//}
//
//#Preview {
//    DayColumn(date: Date(), isSelected: false)
//}
