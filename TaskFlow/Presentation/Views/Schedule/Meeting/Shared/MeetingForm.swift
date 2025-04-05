//
//  StudentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 04.03.2025.
//

import SwiftUI

struct MeetingForm: View {
    
    init(
        meeting: Schedule? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Schedule) -> Void
    ) {
        self.startDate = meeting?.start
        self.finishDate = meeting?.finish
        self.completedDate = meeting?.completed
        self.cost = meeting?.cost ?? 0
        self.details = meeting?.details ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }

    // Поля для ввода данных
    @State private var startDate: Date?
    @State private var finishDate: Date?
    @State private var completedDate: Date?
    @State private var cost: Double
    @State private var details: String
    
    @Binding var isPresented: Bool
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Schedule)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            // Поле для выбора даты начала
            DatePickerButton(caption:"Start", selectedDate: $startDate)

            // Поле для выбора даты окончания
            DatePickerButton(caption:"Finish", selectedDate: $finishDate)
            
            // Поле для выбора даты завершения (если занятие состоялось)
            DatePickerButton(caption:"Completed", selectedDate: $completedDate)

            // Поле для ввода стоимости
            TextField("Cost (rur/60)", value: $cost, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            
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
        .alert("Ошибка", isPresented: $showValidateErrorMsg) {
            Button("OK", role: .cancel) {
                showValidateErrorMsg = false
            }
        } message: {
            Text("Error")
        }
        .formStyle(.grouped)
    }
    private func isValid(meeting: Schedule)->Bool{
        // Стоимость возможна == 0 (бесплатное занятие), но не отрицательная
        
        if let start = meeting.start{
            if meeting.finish != nil && meeting.completed == nil{
                return start <= meeting.finish! && meeting.cost >= 0
            }
            
            if meeting.finish != nil && meeting.completed != nil{
                return start <= meeting.finish! && start <= meeting.completed! && meeting.cost >= 0
            }
        } else{
            return false
        }
        return true
    }
}

#Preview {
    @Previewable @State var isPresent: Bool = false
    MeetingForm(titleForm: "Title Form", captionButtonSuccess: "Success", isPresented: $isPresent){_ in }
}
