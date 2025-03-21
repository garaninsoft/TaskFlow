//
//  DatePickerView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 20.03.2025.
//

import SwiftUI

struct DatePickerButton: View {
    @Binding var selectedDate: Date?
    @State private var showDatePicker = false
    var body: some View {
            VStack(spacing: 20) {
                // Поле для отображения выбранной даты
                HStack {
                    Text(selectedDate?.formatted(date: .abbreviated, time: .shortened) ?? "Дата не выбрана")
                        .foregroundColor(selectedDate == nil ? .gray : .primary)
                    
                    Spacer()
                    
                    // Кнопка для сброса даты
                    if selectedDate != nil {
                        Button(action: {
                            selectedDate = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // Кнопка для открытия DatePicker
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Text("Выбрать дату")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // DatePicker в sheet
                .sheet(isPresented: $showDatePicker) {
                    DatePickerView(selectedDate: $selectedDate)
                }
            }
            .padding()
        }
}


// Отдельное представление для DatePicker
struct DatePickerView: View {
    @Binding var selectedDate: Date?
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempDate = Date() // Временная переменная для DatePicker
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Выберите дату")
                .font(.title)
                .padding(.top, 16)
            
            DatePicker("", selection: $tempDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.stepperField)
                .padding()
            
            HStack {
                Button("Отмена") {
                    dismiss()
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                Button("Сохранить") {
                    selectedDate = tempDate
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .frame(width: 400, height: 400)
        .onAppear {
            // Устанавливаем временную дату при открытии
            tempDate = selectedDate ?? Date()
        }
    }
}
