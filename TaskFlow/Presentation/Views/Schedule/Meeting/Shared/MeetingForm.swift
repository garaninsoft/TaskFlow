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
    
    @State private var minCount = 90
    
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
            Section {
                Text(titleForm)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                
                // Поля для выбора даты
                DatePickerButton(caption: "Начало", selectedDate: $startDate)
                
                HStack {
                    Text("Занятие")
                        .frame(width: 120, alignment: .leading)
                    Spacer()
                    
                    HStack(spacing: 0) {
                        // Блок с числом и Stepper (имеет фон)
                        HStack(spacing: 4) {
                            Text("\(minCount)")
                                .frame(width: 30, alignment: .trailing)
                            
                            Stepper("", value: $minCount, in: 0...240, step: 15)
                                .labelsHidden()
                                .onChange(of: minCount){
                                    if let startDate = startDate{
                                        if let newDate = Calendar.current.date(
                                            byAdding: .minute,
                                            value: minCount,
                                            to: startDate
                                        ) {
                                            finishDate = newDate
                                        }
                                    }
                                }
                                
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(nsColor: .controlBackgroundColor))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                        
                        // Текст "мин" за пределами фона
                        Text("мин")
                            .foregroundColor(.secondary)
                            .frame(width: 100, alignment: .leading)
                            .padding(.leading, 8)
                    }
                    .frame(width: 180, alignment: .trailing)
                }
                
                DatePickerButton(caption: "Окончание", selectedDate: $finishDate)
                DatePickerButton(caption: "Завершено", selectedDate: $completedDate){
                    completedDate = finishDate
                }
        
                // Группа полей стоимости
                VStack(alignment: .leading, spacing: 8) {  // Изменили на .leading
                    // Поле стоимости
                    HStack(alignment: .firstTextBaseline) {
                        Text("Стоимость")
                            .frame(width: 80, alignment: .leading)  // Фиксированная ширина метки
                        Spacer()
                        TextField("", value: $cost, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 250)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: cost) { updateTotalPayment()}
                            .onChange(of: startDate) { updateTotalPayment()}
                            .onChange(of: finishDate) {
                                updateTotalPayment()
                                updateMinCount(start: startDate, finish: finishDate)
                            }
                            .onChange(of: completedDate) { updateTotalPayment()}
                        
                        Text("руб./60 мин")
                            .foregroundColor(.secondary)
                            .frame(width: 90, alignment: .leading)
                    }
                    
                    // Поле суммы (вычисляемое)
                    HStack(alignment: .firstTextBaseline) {
                        Text("К оплате")
                            .frame(width: 80, alignment: .leading)  // Такая же ширина как у "Стоимость"
                        Spacer()
                        Text(
                            completedDate != nil ?
                            totalPayment.formattedAsCurrency(currencySymbol: "")
                            : "не закрыто"
                        )
                        .foregroundColor(.primary)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(nsColor: .controlBackgroundColor))
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 250, alignment: .trailing)
                        Text( completedDate != nil ? "руб" : "")
                            .foregroundColor(.secondary)
                            .frame(width: 90, alignment: .leading)
                    }
                }
                
                // Многострочное поле для деталей
                HStack(alignment: .top) {
                    Text("Детали")
                    Spacer()
                    TextEditor(text: $details)
                        .font(.body)
                        .frame(minHeight: 50, maxHeight: 150)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(nsColor: .textBackgroundColor))
                        )// Фон как у TextField
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .scrollContentBackground(.hidden) // Скрываем стандартный фон
                        .padding(1)
                }
                
            }
            
            // Кнопки действий
            HStack {
                Spacer()
                
                Button("Отмена", role: .cancel) {
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
                    
                    if isValid(meeting: meeting) {
                        withAnimation {
                            action(meeting)
                        }
                        isPresented = false
                    } else {
                        showValidateErrorMsg = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top)
        }
        .formStyle(.grouped)
        .frame(minWidth: 400, idealWidth: 450, maxWidth: 500)
        .padding()
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
        .onAppear{
            updateMinCount(start: startDate, finish: finishDate)
        }
    }
    
    private func updateTotalPayment(){
        self.totalPayment = CostCalculator.calculate(
            start: startDate,
            finish: finishDate,
            cost: cost
        ) ?? 0
    }
    
    private func updateMinCount(start: Date? , finish: Date?){
        if let minCount = CostCalculator.minutesBetweenDates(start: start, end: finish){
            self.minCount = minCount
        }
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

#Preview { Text("Test") }

//#Preview {
//    MeetingForm_Preview()
//    @Previewable @State var completedDate: Date? = Date()
//    DatePickerButton(caption:"Завершено", selectedDate: $completedDate)
//    @Previewable @Environment(\.modelContext) var modelContext
//    @Previewable @State var isPresent: Bool = false
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Schedule.self, configurations: config)
//    MeetingForm(titleForm: "Title Form", captionButtonSuccess: "Success", isPresented: $isPresent, modelContext: container.mainContext){_ in }
//}
