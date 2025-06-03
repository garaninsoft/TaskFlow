//
//  MeetingsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct MeetingsView: View {
    private enum TableConstants {
           static let titleRowHeight: CGFloat = 60
           static let titleBorderHeight: CGFloat = 20
           static let rowBorderHeight: CGFloat = 40
       }

    @ObservedObject var viewModel: MainViewModel
    
    let dataService: MeetingsProtocol
    @State private var meeting: Schedule?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let order = viewModel.selectedOrder{
                // Кастомный Toolbar
                HStack {
                    // Кнопка "Добавить"
                    Button(action: {
                        meeting = nil
                        viewModel.showSheetNewMeeting = true
                    }) {
                        Label("Meeting", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewMeeting) {
                        CreateMeetingView(
                            order: order,
                            meeting: meeting,
                            isPresented: $viewModel.showSheetNewMeeting,
                            dataService: dataService
                        ){}
                    }
                    
                    // Кнопка "Редактировать"
                    Button(action: {
                        viewModel.showSheetEditMeeting = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    .disabled(viewModel.selectedMeeting == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteMeeting, label: "Delete Meeting"){
                        if let meeting = viewModel.selectedMeeting{
                            dataService.delete(meeting: meeting){
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
                    TitleColumnItem(title: "Заня", alignment: .trailing, font: .title3, width: 105, borderHeight: 0),
                    TitleColumnItem(title: "тие", alignment: .leading, font: .title3, width: 105, borderHeight: TableConstants.titleBorderHeight),
                    TitleColumnItem(title: "По плану", alignment: .center, font: .title3, width: 105, borderHeight: TableConstants.titleBorderHeight),
                    TitleColumnItem(title: "По факту", alignment: .center, font: .title3, width: 105, borderHeight: TableConstants.titleBorderHeight),
                    TitleColumnItem(title: "Стоимость 1ч", alignment: .center, font: .title3, width: 105, borderHeight: TableConstants.titleBorderHeight),
                    TitleColumnItem(title: "К оплате", alignment: .center, font: .title3, width: 105, borderHeight: TableConstants.titleBorderHeight),
                    TitleColumnItem(title: "Заметки", alignment: .center, font: .title3, width: 150)
                ]
                // Заголовки колонок
                TableHeader(titleItems: titleItems, rowHeight: TableConstants.titleRowHeight)
               
                
                // Список с данными
                List(order.schedules?.sorted { $0.start ?? Date.distantPast < $1.start ?? Date.distantPast }  ?? []) { meeting in
                    ZeroSpacingHStack {
                        DateTimeFormatText(date: meeting.start)
                            .rightBorderStyle(width: titleItems[0].width, borderHeight: TableConstants.rowBorderHeight)
                        DateTimeFormatText(date: meeting.finish)
                            .rightBorderStyle(width: titleItems[1].width, borderHeight: TableConstants.rowBorderHeight)
                        
                        if let finish = meeting.finish, let start = meeting.start {
                            Text(finish.timeIntervalSince(start).formatDuration())
                                .rightBorderStyle(width: titleItems[2].width, alignment: .trailing, padding:24, borderHeight: TableConstants.rowBorderHeight)
                        } else {
                            Text("--:--")
                                .rightBorderStyle(width: titleItems[2].width, borderHeight: TableConstants.rowBorderHeight)
                        }
                        
                        DateTimeFormatText(date: meeting.completed)
                            .rightBorderStyle(width: titleItems[3].width, borderHeight: TableConstants.rowBorderHeight)
                        
                        Text("\(meeting.cost.formattedAsCurrency())")
                            .font(.system(.callout, design: .default))
                                    .foregroundColor(.blue.opacity(0.4))
                                    .padding(4)
                            .rightBorderStyle(width: titleItems[4].width, alignment: .trailing, padding:8, borderHeight: TableConstants.rowBorderHeight)
                        
                        Text(CostCalculator.calculate(meeting: meeting)?.formattedAsCurrency() ?? "")
                            .font(.system(.callout, design: .default))
                            .foregroundColor(.blue)
                                    .padding(4)
                            .rightBorderStyle(width: titleItems[5].width, alignment: .trailing, padding:8, borderHeight: TableConstants.rowBorderHeight)
                        
                        Text("\(meeting.details)")
                            .rightBorderStyle(width: titleItems[6].width, alignment: .leading, padding:8)
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
            Button("Повтор...") {
                if let selectedMeeting = viewModel.selectedMeeting{
                    meeting = Schedule()
                    meeting?.update(with: selectedMeeting)
                    meeting?.completed = nil
                }else{
                    meeting = nil
                }
                
                viewModel.showSheetNewMeeting = true
            }
            Button("Уменьшить значение") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
            Divider()
            Button("Удалить") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
                .disabled(viewModel.selectedMeeting == nil)
        }
    }
}
