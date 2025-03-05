//
//  StudentForm.swift
//  TaskFlow
//
//  Created by alexandergaranin on 04.03.2025.
//

import SwiftUI

struct StudentForm: View {
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        student: Student? = nil,
        titleForm: String,
        captionButtonSuccess: String,
        action: @escaping (Student) -> Void
    ) {
        
        self.name = student?.name ?? ""
        self.contacts = student?.contacts ?? ""
        
        self.titleForm = titleForm
        self.captionButtonSuccess = captionButtonSuccess
        self.action = action
    }

    @State private var name: String
    @State private var contacts: String
    
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
                    dismiss()
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
                            dismiss()
                        }
                    }else{
                        showValidateErrorMsg.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showValidateErrorMsg) {
                    VStack{
                        XMarkButton().onTapGesture { // on tap gesture calls dismissal
                            showValidateErrorMsg.toggle()
                        }
                        .padding(.trailing)
                        Text("Error")
                    }
                }
            }
        }
        .formStyle(.grouped)
    }
    private func isValid(student: Student)->Bool{
        return !name.isEmpty && !contacts.isEmpty
    }
}

