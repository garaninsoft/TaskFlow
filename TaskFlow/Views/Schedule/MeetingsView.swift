//
//  MeetingsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 18.03.2025.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let value: Int
}

struct MeetingsView: View {
    
    @State private var meetings = [
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 001"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 002"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 003"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 004"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 005"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 006"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 007"),
        Schedule(start: Date(), finish: Date(), completed: Date(), cost: 2000, details: "Android 008")
    ]
    
    @State private var selectedMeeting: Schedule? = nil
    
    @State private var dateFormatter1: DateFormatter = { // Создаем DateFormatter только один раз
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd-MM HH:MM"  // Пример формата
        formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    @State private var dateFormatter2: DateFormatter = { // Создаем DateFormatter только один раз
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM HH:MM"  // Пример формата
        formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Кастомный Toolbar
            HStack {
                // Кнопка "Добавить"
                Button(action: {}) {
                    Label("Meeting", systemImage: "plus")
                }
                
                // Кнопка "Удалить"
                Button(action: {}) {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedMeeting == nil) // Кнопка неактивна, если ничего не выбрано
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
            List(meetings) { meeting in
                HStack {
                    Text(dateFormatter1.string(from: meeting.start))
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    Text(dateFormatter2.string(from:meeting.finish))
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    Text(dateFormatter2.string(from:meeting.completed))
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    Text("\(meeting.cost.formatted(.number.precision(.fractionLength(2))))")
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                    
                    Text("\(meeting.details)")
                        .frame(width: 150, alignment: .leading)
                        .padding(.horizontal, 8)
                }
                .contentShape(Rectangle()) // Чтобы вся строка была кликабельной
                .onTapGesture {
                    selectedMeeting = meeting
                    print("Клик по элементу: \(meeting.details)")
                }
                .background(selectedMeeting?.id == meeting.id ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(4)
            }
        }
        .padding()
        .contextMenu {
            Button("Увеличить значение") { print("Клик по элементу: \(selectedMeeting?.details ?? "")") }
            Button("Уменьшить значение") { print("Клик по элементу: \(selectedMeeting?.details ?? "")") }
            Divider()
            Button("Удалить") { print("Клик по элементу: \(selectedMeeting?.details ?? "")") }
                .disabled(selectedMeeting == nil)
        }
    }
}
