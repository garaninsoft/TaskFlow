//
//  ContentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var students: [Student]
    @State private var showSheetNewStudent = false
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(students) { student in
                    NavigationLink {
                        Text(student.name)
                        StudentDetailView(student: student)
                    } label: {
                        Text(student.name)
                    }
                }
                .onDelete(perform: deleteStudents)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: {showSheetNewStudent.toggle()}) {
                        Label("Add Student", systemImage: "plus")
                    }.sheet(isPresented: $showSheetNewStudent) {
                        CreateStudentView()
                    }
                }
            }
        } detail: {
            Text("Select an Student")
        }
    }
    
    private func deleteStudents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(students[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Student.self, inMemory: true)
}
