//
//  StudentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.03.2025.
//

import SwiftUI

struct CreateStudentView: View {
    @Binding var isPresented: Bool
    let dataService: StudentsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        let template = Student(
            name: "<Факт Имя> t[<Имя в телеге>@<уник имя>]",
            contacts: "телефон",
            details: "",
            created: Date(),
            closed: nil,
            orders: nil
        ) // Это шаблон-подсказка
        StudentForm(
            student: template,
            titleForm: "Create a New Student",
            captionButtonSuccess: "Register",
            isPresented: $isPresented,
            action: {student in
                dataService.create(student: student, onSuccess: onSuccess)
            }
        )
    }
}
