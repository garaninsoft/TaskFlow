//
//  StudentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.03.2025.
//

import SwiftUI

struct CreateStudentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    var body: some View {
        StudentForm(
            titleForm: "Create a New Student",
            captionButtonSuccess: "Register",
            isPresented: $isPresented,
            action: {student in
                modelContext.insert(student)
                try? modelContext.save()
            }
        )
    }
}

