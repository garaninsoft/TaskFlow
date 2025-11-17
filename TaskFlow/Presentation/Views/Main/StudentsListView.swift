//
//  StudentsListView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI

struct StudentsListView: View {
    let students: [Student]
    @State private var selectedStudentID: UUID?
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        List(selection: $selectedStudentID) {
            ForEach(students) { student in
                NavigationLink(value: student){
                    HStack {
                        VStack(alignment: .leading) {
                            Text(student.name)
                            Text(student.details).font(.system(size: 10))
                        }
                        Spacer()
                        VStack(alignment: .leading){
                            Text(student.contacts).fontWeight(.bold)
                            if let messenger = student.messenger {
                                Text(messenger)
                            }
                            if let messenger2 = student.messenger2 {
                                Text(messenger2)
                            }
                        }
                        .font(.system(size: 10))
                        .padding(4)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(6)
                    }
                }
                .tag(student.persistentId)
            }
        }
        .onChange(of: selectedStudentID) {
            let selected = students.first(where: { $0.persistentId == selectedStudentID })
            viewModel.selectStudent(student: selected)
        }
        .onAppear {
            selectedStudentID = viewModel.selectedStudent?.persistentId
        }
    }
}
