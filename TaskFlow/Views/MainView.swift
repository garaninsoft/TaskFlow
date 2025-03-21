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
    @Query(sort: \Student.created, order: .forward) private var students: [Student]
    
    @Binding var selectedStudent: Student?
    @Binding var selectedOrder: Order?
    @Binding var selectedMeeting: Schedule?
    
    @Binding var showSheetNewStudent: Bool
    @Binding var showSheetNewOrder: Bool
    @Binding var showSheetNewMeeting: Bool
    
    @Binding var showSheetEditStudent: Bool
    @Binding var showSheetEditOrder: Bool
    @Binding var showSheetEditMeeting: Bool
    
    @Binding var showConfirmDeleteStudent: Bool
    @Binding var showConfirmDeleteOrder: Bool
    @Binding var showConfirmDeleteMeeting: Bool
    
    // NavigationPath for column Order Detail
    @State private var detailPath = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            // column Students
            List(selection: $selectedStudent) {
                ForEach(students) { student in
                    NavigationLink(student.name, value: student)
                }
                .onChange(of: selectedStudent) {
                    selectedOrder = nil
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {showSheetNewStudent = true}) {
                        Label("Add Student", systemImage: "plus")
                    }
                    .sheet(isPresented: $showSheetNewStudent) {
                        CreateStudentView(isPresented: $showSheetNewStudent)
                    }
                }
                if let student = selectedStudent {
                    ToolbarItem {
                        Button(action: {showSheetEditStudent = true}) {
                            Label("Edit Student", systemImage: "pencil")
                        }
                        .sheet(isPresented: $showSheetEditStudent) {
                            UpdateStudentView(isPresented: $showSheetEditStudent, student: student)
                        }
                    }
                    ToolbarItem {
                        TrashConfirmButton(isPresent: $showConfirmDeleteStudent, label: "Delete Student"){
                            deleteStudent(student: student)
                        }
                    }
                }
            }
        } content:{
            // column Orders
            NavigationStack{
                if let student = selectedStudent {
                    let orders = student.orders ?? []
                    if !orders.isEmpty {
                        List(orders, selection: $selectedOrder) { order in
                            NavigationLink(order.title, value: order)
                        }
                        .onChange(of: selectedOrder) {
                            selectedMeeting = nil
                        }
                    }else{
                        Text("No Orders")
                    }
                } else {
                    Text("Select Student")
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                if let student = selectedStudent {
                    ToolbarItem {
                        Button(action: {showSheetNewOrder = true}) {
                            Label("Add Order", systemImage: "plus")
                        }
                        .sheet(isPresented: $showSheetNewOrder) {
                            CreateOrderView(student: student, isPresented: $showSheetNewOrder)
                        }
                    }
                    if let order = selectedOrder {
                        ToolbarItem {
                            Button(action: {showSheetEditOrder = true}) {
                                Label("Edit Order", systemImage: "pencil")
                            }
                            .sheet(isPresented: $showSheetEditOrder) {
                                UpdateOrderView(isPresented: $showSheetEditOrder, order: order)
                            }
                        }
                        ToolbarItem {
                            TrashConfirmButton(isPresent: $showConfirmDeleteOrder, label: "Delete Order"){
                                deleteStudent(student: student)
                            }
                        }
                    }
                }
            }
        } detail: {
            // column Order Details
            NavigationStack(path: $detailPath) {
                if let order = selectedOrder {
                    OrderDetailsView(
                        order: order,
                        selectedMeeting: $selectedMeeting,
                        showSheetNewMeeting: $showSheetNewMeeting,
                        showConfirmDeleteMeeting: $showConfirmDeleteMeeting,
                        actionDeleteMeeting: deleteMeeting
                    )
                } else {
                    Text("Select Order")
                }
            }
        }
    }
    
    private func deleteStudent(student: Student){
        withAnimation{
            modelContext.delete(student)
        }
    }
    
    private func deleteOrder(order: Order){
        withAnimation{
            modelContext.delete(order)
        }
    }
    
    private func deleteMeeting(meeting: Schedule){
        withAnimation{
            modelContext.delete(meeting)
        }
    }
}

