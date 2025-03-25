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
                                actionUpdateMeeting: meetingsProtocol.actionUpdateMeeting
                            )
                        }
                    }
                    .disabled(viewModel.selectedMeeting == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteMeeting, label: "Delete Meeting"){
                        if let meeting = viewModel.selectedMeeting{
                            meetingsProtocol.actionDeleteMeeting(meeting: meeting)
                        }
                    }
                    .disabled(viewModel.selectedMeeting == nil) // Кнопка неактивна, если ничего не выбрано
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                // Заголовки колонок
                HStack {
                    Text("Start")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Finish")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Completed")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Cost rur/60")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                    Text("Details")
                        .frame(width: 150, alignment: .leading)
                        .font(.headline)
                        .padding(.horizontal, 8)
                    
                }
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                
                // Список с данными
                List(order.schedules ?? []) { meeting in
                    HStack {
                        DateTimeFormatText(date: meeting.start, format: .format1)
                        DateTimeFormatText(date: meeting.finish, format: .format2)
                        DateTimeFormatText(date: meeting.completed, format: .format2)
                        
                        Text("\(meeting.cost.formatted(.number.precision(.fractionLength(2))))")
                            .frame(width: 150, alignment: .leading)
                            .padding(.horizontal, 8)
                        
                        Text("\(meeting.details)")
                            .frame(width: 150, alignment: .leading)
                            .padding(.horizontal, 8)
                    }
                    .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                    .onTapGesture {
                        viewModel.selectedMeeting = meeting
                        print("Клик по элементу: \(meeting.details)")
                    }
                    .background(viewModel.selectedMeeting?.id == meeting.id ? Color.blue.opacity(0.2) : Color.clear)
                    .cornerRadius(4)
                }
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
