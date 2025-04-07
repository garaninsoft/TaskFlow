//
//  StudentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.03.2025.
//

import SwiftUI

struct UpdateStudentView: View {
    var student: Student
    
    @Binding var isPresented: Bool
    let dataService: StudentsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        StudentForm(
            student: student,
            titleForm: "Update Student",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: {student in
                dataService.update(student: student, onSuccess: onSuccess)
            }
        )
    }
}

