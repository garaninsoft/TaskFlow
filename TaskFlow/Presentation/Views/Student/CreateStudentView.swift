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
        StudentForm(
            titleForm: "Create a New Student",
            captionButtonSuccess: "Register",
            isPresented: $isPresented,
            action: {student in
                dataService.create(student: student, onSuccess: onSuccess)
            }
        )
    }
}

