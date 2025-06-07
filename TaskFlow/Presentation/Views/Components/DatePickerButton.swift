//
//  DatePickerView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 20.03.2025.
//

import SwiftUI

struct DatePickerButton: View {
    let caption: String
    
    @Binding var selectedDate: Date?
    @State private var showDatePicker = false
    var action: (()->Void)? = nil
    var body: some View {
        // Поле для отображения выбранной даты
        HStack {
            Text(caption)
            Spacer()
            HStack {
                Text(selectedDate?.formatted(date: .abbreviated, time: .shortened) ?? "Дата не выбрана")
                    .foregroundColor(selectedDate == nil ? .gray : .primary)
                
                // Кнопка для сброса даты
                if selectedDate != nil {
                    Button( action: {
                        selectedDate = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Кнопка для открытия DatePicker
                Button("Выбрать дату"){
                    showDatePicker.toggle()
                }
                
                // DatePicker в sheet
                .sheet(isPresented: $showDatePicker) {
                    DatePickerView(selectedDate: $selectedDate, action: action)
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
}


// Отдельное представление для DatePicker
struct DatePickerView: View {
    @Binding var selectedDate: Date?
    @Environment(\.dismiss) private var dismiss
    @State private var tempDate = Date()
    
    var action: (()->Void)? = nil
    
    var body: some View {
        VStack(spacing: 1) {
            Text("Выберите дату")
                .font(.title)
                .padding(.top, 8)
            
            DatePicker("", selection: $tempDate, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.stepperField)
                .padding()
            
            HStack {
                Button("Отмена") {
                    dismiss()
                }
            
                
                Button("Сохранить") {
                    selectedDate = tempDate.roundedToMinutes()
                    dismiss()
                    if let action = action{
                        action()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)  // Синий цвет
                .keyboardShortcut(.defaultAction)  // Нажатие Enter
            }

        }
        .padding()
//        .frame(width: 400, height: 400)
        .onAppear {
            // Устанавливаем временную дату при открытии
            tempDate = selectedDate ?? Date()
        }
    }
}

extension Date {
    func roundedToMinutes(calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components) ?? self
    }
}

//#Preview {
//    @Previewable @State var selectedDate: Date? = Date()
//    DatePickerView(selectedDate: $selectedDate)
//}
//
//#Preview {
//    @Previewable @State var selectedDate: Date? = Date()
//    DatePickerButton(caption: "Caption", selectedDate: $selectedDate)
//}
