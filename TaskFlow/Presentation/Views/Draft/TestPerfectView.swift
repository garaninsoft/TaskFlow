//
//  StatisticsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 28.03.2025.
//

import SwiftUI

struct TableItem: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let progress: Double
    let date: Date
    let priority: Priority
    
    enum Priority: String, CaseIterable {
        case low = "Низкий"
        case medium = "Средний"
        case high = "Высокий"
        
        var color: Color {
            switch self {
            case .low: return .green
            case .medium: return .yellow
            case .high: return .red
            }
        }
    }
}


struct TestPerfectView: View {
    @State private var selection: Set<TableItem.ID> = []
       @State private var sortOrder = [KeyPathComparator(\TableItem.name)]
       
       private var items: [TableItem] {
           return [
               TableItem(name: "Рефакторинг кода", status: "В работе", progress: 0.35, date: Date().addingTimeInterval(-86400), priority: .medium),
               TableItem(name: "Дизайн интерфейса", status: "Завершено", progress: 1.0, date: Date().addingTimeInterval(-172800), priority: .high),
               TableItem(name: "Тестирование", status: "Ожидает", progress: 0.0, date: Date().addingTimeInterval(86400), priority: .low),
               TableItem(name: "Документация", status: "В работе", progress: 0.65, date: Date().addingTimeInterval(-43200), priority: .medium)
           ].sorted(using: sortOrder)
       }
       
       @Environment(\.dismiss) var dismiss
       
       var body: some View {
           NavigationStack {
               VStack(spacing: 0) {
                   // Таблица с возможностью выбора и сортировки
                   Table(items, selection: $selection, sortOrder: $sortOrder) {
                       TableColumn("Задача", value: \.name) { item in
                           HStack {
                               Circle()
                                   .fill(item.priority.color)
                                   .frame(width: 8, height: 8)
                               Text(item.name)
                                   .lineLimit(1)
                           }
                       }
                       
                       TableColumn("Статус", value: \.status) { item in
                           StatusBadge(status: item.status)
                       }
                       
                       TableColumn("Прогресс", value: \.progress) { item in
                           ProgressView(value: item.progress)
                               .progressViewStyle(.linear)
                               .frame(width: 150)
                       }
                       
                       TableColumn("Срок", value: \.date) { item in
                           Text(item.date.formatted(date: .numeric, time: .omitted))
                               .foregroundStyle(item.date < Date() ? .red : .primary)
                       }
                       
                       TableColumn("Приоритет", value: \.priority.rawValue)
                   }
                   .tableStyle(.bordered)
                   .contextMenu {
                       if let selectedItem = items.first(where: { $0.id == selection.first }) {
                           Section {
                               Button("Отметить как завершенное") {
                                   // Действие
                               }
                               Button("Изменить приоритет") {
                                   // Действие
                               }
                           }
                           
                           Divider()
                           
                           Button("Удалить") {
                               // Действие
                           }
                       } else {
                           Text("Выберите элемент")
                       }
                   }
                   
                   // Панель инструментов
                   HStack {
                       Text("\(selection.count) выбрано")
                           .foregroundStyle(.secondary)
                       
                       Spacer()
                       
                       Button(action: { dismiss() }) {
                           Text("Закрыть")
                       }
                       .keyboardShortcut(.cancelAction)
                       
                       Button(action: { /* Сохранить */ }) {
                           Text("Сохранить")
                       }
                       .keyboardShortcut(.defaultAction)
                   }
                   .padding()
                   .background(.bar)
               }
               .frame(minWidth: 600, minHeight: 400)
               .navigationTitle("Менеджер задач")
               .toolbar {
                   ToolbarItemGroup {
                       Button(action: { /* Добавить */ }) {
                           Label("Добавить", systemImage: "plus")
                       }
                       
                       Picker("Сортировка", selection: .constant(1)) {
                           Text("По имени").tag(1)
                           Text("По дате").tag(2)
                           Text("По приоритету").tag(3)
                       }
                   }
               }
           }
       }
}

struct StatusBadge: View {
    let status: String
    
    var color: Color {
        switch status {
        case "Завершено": return .green
        case "В работе": return .blue
        default: return .gray
        }
    }
    
    var body: some View {
        Text(status)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(4)
    }
}


#Preview {
    
    TestPerfectView()
}
