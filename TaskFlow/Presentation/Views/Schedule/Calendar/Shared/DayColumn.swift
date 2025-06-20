//
//  DayColumn.swift
//  TaskFlow
//
//  Created by alexandergaranin on 26.03.2025.
//

import SwiftUI

struct DayColumn: View {
    @ObservedObject var viewModel: MainViewModel
    @StateObject private var folderViewModel = FolderViewModel()
    
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
               .fill(busyMinute.meeting.status.color) // Цвет занятого времени
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
                   Button("Редактировать"){
                       viewModel.selectedMeeting = busyMinute.meeting
                       viewModel.showSheetEditMeeting = true
                   }
                   
                   Button("Повторить") {
                       viewModel.selectedOrder = busyMinute.meeting.order
                       viewModel.selectedMeeting = busyMinute.meeting
                       viewModel.showSheetNewMeeting = true
                   }
                   
                   Button("Папка заказа") {
                       folderViewModel.createAndOpenOrderFolder(for: busyMinute.meeting.order)
                   }
                   
                   Button("Заказ") {
                       
                       if let student = busyMinute.meeting.order?.student{
                           viewModel.selectedStudent = student
                           viewModel.selectedOrder = busyMinute.meeting.order
                           viewModel.selectedWindowGroupTab = .main
                       }
                   }
               }
       }
}
