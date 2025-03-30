//
//  StudentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 04.03.2025.
//

import SwiftUI

struct StudentForm: View {
    
    init(
        student: Student? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        isPresented: Binding<Bool>,
        action: @escaping (Student) -> Void
    ) {
        self.name = student?.name ?? ""
        self.contacts = student?.contacts ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
        self._isPresented = isPresented
    }

    @State private var name: String
    @State private var contacts: String
    
    @Binding var isPresented: Bool
    
    var titleForm: String
    var captionButtonSuccess: String
    var action: (Student)->Void
    
    @State private var showValidateErrorMsg = false
    
    var body: some View {
        Form {
            Text(titleForm)
                .font(.title2)
            
            TextField("Name", text: $name)
            TextField("Contacts", text: $contacts)
            
            HStack {
                
                Button("Cancel", role: .cancel) {
                    isPresented = false
                }
                
                Button(captionButtonSuccess) {
                    let student = Student(
                        name: name,
                        contacts: contacts,
                        created: Date()
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
        return !name.isEmpty && !contacts.isEmpty
    }
}

