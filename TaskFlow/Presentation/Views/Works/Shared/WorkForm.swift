//
//  WorkForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.04.2025.
//

import SwiftUI

struct WorkForm: View {
    init(
        work: Work? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Work) -> Void
    ) {
        self.created = work?.created
        self.completed = work?.completed
        self.cost = work?.cost ?? 0
        self.details = work?.details ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }

    // Поля для ввода данных
    @State private var created: Date?
    @State private var completed: Date?
    @State private var cost: Double
    @State private var details: String
    
    @Binding var isPresented: Bool
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Work)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            // Поле для выбора даты начала
            DatePickerButton(caption:"Created", selectedDate: $created)

            // Поле для выбора даты окончания
            DatePickerButton(caption:"Completed", selectedDate: $completed)

            // Поле для ввода стоимости
            TextField("Cost", value: $cost, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            
            // Поле для ввода деталей
            TextField("Details", text: $details)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            
            HStack {
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    
                    let work = Work(
                        created: created,
                        completed: completed,
                        cost: cost,
                        details: details
                    )
                    if isValid(work: work){
                        withAnimation {
                            action(work)
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
    private func isValid(work: Work)->Bool{
        // Стоимость возможна == 0 (бесплатнае работа), но не отрицательная
        // created     - обязательно
        // completed   - по завершению работы
        
        if let created = work.created{
            if work.completed != nil{
                return created <= work.completed! && work.cost >= 0
            }else{
                return work.cost >= 0
            }
        } else{
            return false
        }
    }
}

#Preview {
    //WorkForm()
}
