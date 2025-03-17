//
//  StudentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 02.03.2025.
//

import SwiftUI

struct UpdateStudentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    var student: Student
    
    var body: some View {
        StudentForm(
            student: student,
            titleForm: "Update Student",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: updateStudent
        )
    }
    
    func updateStudent(_ student: Student){
        self.student.name = student.name
        self.student.contacts = student.contacts
        try? modelContext.save()
    }
}

