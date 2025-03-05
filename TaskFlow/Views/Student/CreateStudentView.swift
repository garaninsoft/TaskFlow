//
//  StudentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.03.2025.
//

import SwiftUI

struct CreateStudentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        StudentForm(
            titleForm: "Create a New Student",
            captionButtonSuccess: "Register",
            action: modelContext.insert
        )
    }
}

#Preview {
    CreateStudentView()
}
