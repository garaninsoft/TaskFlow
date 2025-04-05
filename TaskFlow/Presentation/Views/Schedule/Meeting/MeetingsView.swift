//
//  MeetingsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct MeetingsView: View {

    @ObservedObject var viewModel: MainViewModel
    
    let meetingsProtocol: MeetingsProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let order = viewModel.selectedOrder{
                // Кастомный Toolbar
                HStack {
                    // Кнопка "Добавить"
                    Button(action: {
                        viewModel.showSheetNewMeeting = true
                    }) {
                        Label("Meeting", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewMeeting) {
                        CreateMeetingView(order: order, isPresented: $viewModel.showSheetNewMeeting)
                    }
                    
                    // Кнопка "Редактировать"
                    Button(action: {
                        viewModel.showSheetEditMeeting = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    .sheet(isPresented: $viewModel.showSheetEditMeeting) {
                        if let meeting = viewModel.selectedMeeting{
                            UpdateMeetingView(
                                meeting: meeting,
                                isPresented: $viewModel.showSheetEditMeeting,
                                actionUpdateMeeting: { meeting in
                                    meetingsProtocol.actionUpdateMeeting(meeting: meeting){}
                                }
                            )
                        }
                    }
                    .disabled(viewModel.selectedMeeting == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteMeeting, label: "Delete Meeting"){
                        if let meeting = viewModel.selectedMeeting{
                            meetingsProtocol.actionDeleteMeeting(meeting: meeting){
                                viewModel.selectedMeeting = nil
                            }
                        }
                    }
                    .disabled(viewModel.selectedMeeting == nil) // Кнопка неактивна, если ничего не выбрано
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                // Заголовки колонок
                let titleItems = [
                    TitleColumnItem(title: "Start", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Finish", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Completed", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Cost 60 min", alignment: .center, font: .title3, width: 90, borderHeight: 20),
                    TitleColumnItem(title: "Details", alignment: .center, font: .title3, width: 150, borderHeight: 0)
                ]
                // Заголовки колонок
                TableHeader(titleItems: titleItems)
                
                
                // Список с данными
                List(order.schedules?.sorted { $0.start ?? Date.distantPast < $1.start ?? Date.distantPast }  ?? []) { meeting in
                    ZeroSpacingHStack {
                        DateTimeFormatText(date: meeting.start)
                            .rightBorderStyle(width: titleItems[0].width, borderHeight: 40)
                        DateTimeFormatText(date: meeting.finish)
                            .rightBorderStyle(width: titleItems[1].width, borderHeight: 40)
                        DateTimeFormatText(date: meeting.completed)
                            .rightBorderStyle(width: titleItems[2].width, borderHeight: 40)
                        
                        Text("\(meeting.cost.formattedAsCurrency())")
                            .font(.system(.subheadline, design: .monospaced))
                                    .foregroundColor(.blue)
                                    .padding(4)
                            .rightBorderStyle(width: titleItems[3].width, alignment: .trailing, padding:8, borderHeight: 40)
                        
                        Text("\(meeting.details)")
                            .rightBorderStyle(width: titleItems[4].width, alignment: .leading, padding:8)
                    }
                    .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                    .onTapGesture {
                        viewModel.selectedMeeting = meeting
                        print("Клик по элементу: \(meeting.details)")
                    }
                    .background(viewModel.selectedMeeting?.id == meeting.id ? Color.blue.opacity(0.2) : Color.clear)
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .contextMenu {
            Button("Увеличить значение") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
            Button("Уменьшить значение") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
            Divider()
            Button("Удалить") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
                .disabled(viewModel.selectedMeeting == nil)
        }
    }
}
