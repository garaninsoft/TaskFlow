//
//  ContentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 15.01.2025.
//

import SwiftUI
import SwiftData

struct MainView: View {
    // Logging Debug (import os enabled)
//    private static let logger = Logger(
//            subsystem: "mySubsystem",
//            category: String(describing: Self.self)
//    )
//    let _ = Self.logger.trace("hello \(student.name)") // sample logging

    
    @Environment(\.modelContext) private var modelContext
    @Query private var students: [Student]
    
    @Binding var selectedStudent: Student?
    @State private var selectedOrder: Order?
    
    @Binding var showSheetNewStudent: Bool
    
    // NavigationPath for column Order Detail
    @State private var detailPath = NavigationPath()
    
    
    
    var body: some View {
        NavigationSplitView {
            // column Students
            List(selection: $selectedStudent) {
                ForEach(students) { student in
                    NavigationLink(student.name, value: student)
                }
                .onDelete(perform: deleteStudents)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {showSheetNewStudent.toggle()}) {
                        Label("Add Student", systemImage: "plus")
                    }.sheet(isPresented: $showSheetNewStudent) {
                        CreateStudentView(isPresented: $showSheetNewStudent)
                    }
                }
            }
            
        } content:{
            // column Orders
            NavigationStack{
                if let student = selectedStudent {
                    List(student.orders ?? [], selection: $selectedOrder) { order in
                        NavigationLink(order.title, value: order)
                    }
                } else {
                    Text("Select Student")
                }
            }
            .navigationTitle("Orders")
        } detail: {
            // column Order Details
            NavigationStack(path: $detailPath) {
                if let order = selectedOrder {
                    Text(order.details)
                } else {
                    Text("Select Order")
                }
            }
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

