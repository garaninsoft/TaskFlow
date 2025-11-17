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
            name: "",
            details: "",
            created: Date()
        )
        StudentForm(
            student: template,
            titleForm: "Новый ученик",
            captionButtonSuccess: "Создать",
            isPresented: $isPresented,
            action: {student in
                dataService.create(student: student, onSuccess: onSuccess)
            }
        )
    }
}
