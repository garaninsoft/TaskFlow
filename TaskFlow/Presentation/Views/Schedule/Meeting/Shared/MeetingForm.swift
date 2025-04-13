//
//  StudentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 04.03.2025.
//

import SwiftUI
import SwiftData

struct MeetingForm: View {
    // Поля для ввода данных
    @State private var startDate: Date?
    @State private var finishDate: Date?
    @State private var completedDate: Date?
    @State private var cost: Double
    @State private var details: String
    
    @State private var totalPayment: Double
    
    @Binding var isPresented: Bool
    
    @State private var errorMessage: String = "Ошибка"
    private let scheduleID: Schedule.ID?
    private let modelContext: ModelContext
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Schedule)->Void
    
    @State private var showValidateErrorMsg = false
    @State private var meetingConflict: Schedule? = nil
    
    init(
        meeting: Schedule? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        modelContext: ModelContext, // Для проверки пересечений по времени занятий
        action: @escaping (Schedule) -> Void
    ) {
        self.startDate = meeting?.start
        self.finishDate = meeting?.finish
        self.completedDate = meeting?.completed
        self.cost = meeting?.cost ?? 0
        self.details = meeting?.details ?? ""
        
        self.scheduleID = meeting?.id
        self.modelContext = modelContext
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
        if let meeting = meeting{
            self.totalPayment = CostCalculator.calculate(meeting: meeting) ?? 0
        }else{
            self.totalPayment = 0
        }
    }
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            // Поле для выбора даты начала
            DatePickerButton(caption:"Начало", selectedDate: $startDate)
            

            // Поле для выбора даты окончания
            DatePickerButton(caption:"Окончание", selectedDate: $finishDate)
                .onChange(of: finishDate){ oldValue, newValue in
                    if let newValue {
                        if let calcTotal = CostCalculator.calculate(
                            start: startDate, calcValue: newValue, cost: cost
                        ){
                            totalPayment = calcTotal
                        }
                    }
                }
            
            // Поле для выбора даты завершения (если занятие состоялось)
            DatePickerButton(caption:"Завершено", selectedDate: $completedDate)

            // Поле для ввода стоимости
            HStack{
                TextField("Стоимость", value: $cost, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(" руб./60 мин")
            }
            
            HStack{
                TextField("Сумма", value: $totalPayment, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text(" руб")
                Button("Расчёт окончания") {
                    if let calcFinishData = Schedule.calculateFinishMeeting(
                        startDate: startDate,
                        totalPayment: totalPayment,
                        hourlyRate: cost){
                        finishDate = calcFinishData
                    }else{
                        errorMessage = "Не хватает для расчёта данных"
                        showValidateErrorMsg = true
                    }
                }
            }
            
            // Поле для ввода деталей
            TextField("Details", text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    
                    let meeting = Schedule(
                        start: startDate,
                        finish: finishDate,
                        completed: completedDate,
                        cost: cost,
                        details: details
                    )
                    if isValid(meeting: meeting){
                        withAnimation {
                            action(meeting)
                        }
                        isPresented = false
                    }else{
                        showValidateErrorMsg = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert(errorMessage, isPresented: $showValidateErrorMsg) {
            Button("OK", role: .cancel) {
                showValidateErrorMsg = false
            }
        } message: {
            if let meetingConflict = self.meetingConflict {
                // Основной текст с форматированием
                let studentText = meetingConflict.order?.student.map { "Студент: **\($0.name)**" } ?? ""
                let orderText = meetingConflict.order.map { "Заказ: **\($0.title)**" } ?? ""
                let startText = "Начало: \(meetingConflict.start?.formatted(date: .omitted, time: .shortened) ?? "не указано")"
                let endText = "Окончание: \(meetingConflict.finish?.formatted(date: .omitted, time: .shortened) ?? "не указано")"
                
                // Комбинируем все тексты
                Text("\(studentText)\n\(orderText)\n\(startText)\n\(endText)")
            }
        }
        .formStyle(.grouped)
    }
    private func isValid(meeting: Schedule)->Bool{
        // Стоимость возможна == 0 (бесплатное занятие), но не отрицательная
        
        //Сброс перед проверкой
        errorMessage = "Ошибка валидации" // по умолчанию
        self.meetingConflict = nil
        
        if let start = meeting.start, let finish = meeting.finish{
            // Сначала проверим на пересечение с уже запланированными занятиями.
            if let meetingConflict =  Schedule.findTimeConflict(
                withStart: start,
                finish: finish,
                buffer: 15 * 60,
                excluding: scheduleID, // Исключаем текущее событие, если есть
                in: modelContext
            ) {
                if meetingConflict.order != nil{ // meetingConflict.order проверяем на тот случай, если в бд
                    // болтаются события у которых уже нет заказов. Каскадное удаление возможно будет добавлено.
                    errorMessage = "Найдено конфликтующее событие:"
                    self.meetingConflict = meetingConflict
                    return false
                }
            }
            
            if let completed = meeting.completed{
                // Начал о занятия <= Конец занятия и Начало занятия <= Фактический конец занятия
                return start <= finish && start <= completed && meeting.cost >= 0
                
            }else{
                // Начало занятия <= Конец занятия
                return start <= finish && meeting.cost >= 0
            }
        }
        return false
        
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var modelContext
    @Previewable @State var isPresent: Bool = false
    MeetingForm(titleForm: "Title Form", captionButtonSuccess: "Success", isPresented: $isPresent, modelContext: modelContext){_ in }
}
