//
//  StudentsListView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI

struct StudentsListView: View {
    let students: [Student]
    @State private var selectedStudent: Student?
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        List(selection: $selectedStudent) {
            ForEach(students) { student in
                NavigationLink(student.name, value: student)
            }
            .onChange(of: selectedStudent) {
                viewModel.selectStudent(student: selectedStudent)
            }
            .onAppear {
                if let student = viewModel.selectedStudent{
                    selectedStudent = student
                }
//                selectedStudent = nil
//                viewModel.selectStudent(student: nil)
            }
        }
    }

}
