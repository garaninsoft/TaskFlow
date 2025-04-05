//
//  WorksView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct WorksView: View {
    
    @ObservedObject var viewModel: MainViewModel
    let worksProtocol: WorksProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let order = viewModel.selectedOrder{
                // Кастомный Toolbar
                HStack {
                    // Кнопка "Добавить"
                    Button(action: {
                        viewModel.showSheetNewWork = true
                    }) {
                        Label("Work", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewWork) {
                        CreateWorkView(order: order, isPresented: $viewModel.showSheetNewWork)
                    }
                    
                    // Кнопка "Редактировать"
                    Button(action: {
                        viewModel.showSheetEditWork = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    .sheet(isPresented: $viewModel.showSheetEditWork) {
                        if let work = viewModel.selectedWork{
                            UpdateWorkView(
                                work: work,
                                isPresented: $viewModel.showSheetEditWork,
                                actionUpdateWork: { work in
                                    worksProtocol.actionUpdateWork(work: work){
                                        viewModel.selectedWork = nil
                                    }
                                }
                            )
                        }
                    }
                    .disabled(viewModel.selectedWork == nil)
                    
                    // Кнопка "Удалить"
                    TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteWork, label: "Delete Work"){
                        if let work = viewModel.selectedWork{
                            worksProtocol.actionDeleteWork(work: work){
                                viewModel.selectedWork = nil
                            }
                        }
                    }
                    .disabled(viewModel.selectedWork == nil) // Кнопка неактивна, если ничего не выбрано
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                // Заголовки колонок
                let titleItems = [
                    TitleColumnItem(title: "Created", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Completed", alignment: .center, font: .title3, width: 120, borderHeight: 20),
                    TitleColumnItem(title: "Cost", alignment: .center, font: .title3, width: 90, borderHeight: 20),
                    TitleColumnItem(title: "Details", alignment: .center, font: .title3, width: 150, borderHeight: 0)
                ]
                // Заголовки колонок
                TableHeader(titleItems: titleItems)
                
                
                // Список с данными
                List(order.works?.sorted { $0.created ?? Date.distantPast < $1.created ?? Date.distantPast }  ?? []) { work in
                    ZeroSpacingHStack {
                        DateTimeFormatText(date: work.created)
                            .rightBorderStyle(width: titleItems[0].width, borderHeight: 40)
                        DateTimeFormatText(date: work.completed)
                            .rightBorderStyle(width: titleItems[1].width, borderHeight: 40)
                        
                        Text("\(work.cost.formattedAsCurrency())")
                            .font(.system(.subheadline, design: .monospaced))
                                    .foregroundColor(.blue)
                                    .padding(4)
                            .rightBorderStyle(width: titleItems[2].width, alignment: .trailing, padding:8, borderHeight: 40)
                        
                        Text("\(work.details)")
                            .rightBorderStyle(width: titleItems[3].width, alignment: .leading, padding:8)
                    }
                    .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                    .onTapGesture {
                        viewModel.selectedWork = work
                        print("Клик по элементу: \(work.details)")
                    }
                    .background(viewModel.selectedWork?.id == work.id ? Color.blue.opacity(0.2) : Color.clear)
                }
                .listStyle(.plain)
            }
        }
        .padding()
//        .contextMenu {
//            Button("Увеличить значение") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
//            Button("Уменьшить значение") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
//            Divider()
//            Button("Удалить") { print("Клик по элементу: \(viewModel.selectedMeeting?.details ?? "")") }
//                .disabled(viewModel.selectedMeeting == nil)
//        }
    }
}

#Preview {
    //WorksView()
}
