//
//  StudentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 04.03.2025.
//

import SwiftUI

struct StudentForm: View {
    @State private var name: String
    @State private var contacts: String
    @State private var contacts2: String
    @State private var messenger: String
    @State private var messenger2: String
    @State private var details: String
    @State private var created: Date?
    @State private var closed: Date?
    
    @Binding var isPresented: Bool
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Student)->Void
    
    @State private var showValidateErrorMsg = false
    
    init(
        student: Student? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Student) -> Void
    ) {
        self.name = student?.name ?? ""
        self.contacts = student?.contacts ?? ""
        self.contacts2 = student?.contacts2 ?? ""
        self.messenger = student?.messenger ?? ""
        self.messenger2 = student?.messenger2 ?? ""
        self.details = student?.details ?? ""
        self.created = student?.created ?? Date()
        self.closed = student?.closed
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            TextField("Имя", text: $name)
            // Группа контактов
            Section("Контакты") {
                TextField("Основной", text: $contacts)
                TextField("Дополнительный", text: $contacts2)
            }
            
            // Группа мессенджеров
            Section("Мессенджеры") {
                TextField("Основной", text: $messenger)
                TextField("Дополнительный", text: $messenger2)
            }
            TextField("Детали", text: $details)
            DatePickerButton(caption:"Создан", selectedDate: $created)
            DatePickerButton(caption:"Закрыт", selectedDate: $closed)
            
            HStack {
                
                Button("Отмена", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    let student = Student(
                        name: name,
                        contacts: contacts,
                        contacts2: contacts2,
                        messenger: messenger,
                        messenger2: messenger2,
                        details: details,
                        created: created,
                        closed: closed
                    )
                    if isValid(student: student){
                        withAnimation {
                            action(student)
                        }
                        isPresented = false
                    }else{
                        showValidateErrorMsg.toggle()
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
    private func isValid(student: Student)->Bool{
        return !name.isEmpty && !contacts.isEmpty && created != nil
    }
}

//#Preview {
//    @Previewable @State var isPresented = true
//    StudentForm(
//        titleForm: "Заголовок",
//        captionButtonSuccess: "Ok",
//        isPresented: $isPresented,
//        action: {_ in })
//}
