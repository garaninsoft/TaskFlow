//
//  StudentDetailView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 03.03.2025.
//

import SwiftUI

struct StudentDetailView: View {
    @State private var showSheetNewStudent = false
    
    var student: Student
 
    var body: some View {
        VStack{
            Text(student.name)
            Text("Orders")
            Button("Update"){
                showSheetNewStudent.toggle()
            }.sheet(isPresented: $showSheetNewStudent) {
                UpdateStudentView(student: student)
            }
        }
    }
}

#Preview {
    StudentDetailView(student: Student(name: "Vasia", contacts: "123", created: Date()))
}
