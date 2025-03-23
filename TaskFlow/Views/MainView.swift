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

    @ObservedObject var viewModel: MainViewModel
    
    // NavigationPath for column Order Detail
    @State private var detailPath = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            // column Students
            List(selection: $viewModel.selectedStudent) {
                ForEach(students) { student in
                    NavigationLink(student.name, value: student)
                }
                .onChange(of: viewModel.selectedStudent) {
                    viewModel.selectedOrder = nil
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {viewModel.showSheetNewStudent = true}) {
                        Label("Add Student", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewStudent) {
                        CreateStudentView(isPresented: $viewModel.showSheetNewStudent)
                    }
                }
                if let student = viewModel.selectedStudent {
                    ToolbarItem {
                        Button(action: {viewModel.showSheetEditStudent = true}) {
                            Label("Edit Student", systemImage: "pencil")
                        }
                        .sheet(isPresented: $viewModel.showSheetEditStudent) {
                            UpdateStudentView(isPresented: $viewModel.showSheetEditStudent, student: student)
                        }
                    }
                    ToolbarItem {
                        TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteStudent, label: "Delete Student"){
                            deleteStudent(student: student)
                            viewModel.selectedStudent = nil
                        }
                    }
                }
            }
        } content:{
            // column Orders
            NavigationStack{
                if let student = viewModel.selectedStudent {
                    let orders = student.orders ?? []
                    if !orders.isEmpty {
                        List(orders, selection: $viewModel.selectedOrder) { order in
                            NavigationLink(order.title, value: order)
                        }
                        .onChange(of: viewModel.selectedOrder) {
                            viewModel.selectedMeeting = nil
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
                if let student = viewModel.selectedStudent {
                    ToolbarItem {
                        Button(action: {viewModel.showSheetNewOrder = true}) {
                            Label("Add Order", systemImage: "plus")
                        }
                        .sheet(isPresented: $viewModel.showSheetNewOrder) {
                            CreateOrderView(student: student, isPresented: $viewModel.showSheetNewOrder)
                        }
                    }
                    if let order = viewModel.selectedOrder {
                        ToolbarItem {
                            Button(action: {viewModel.showSheetEditOrder = true}) {
                                Label("Edit Order", systemImage: "pencil")
                            }
                            .sheet(isPresented: $viewModel.showSheetEditOrder) {
                                UpdateOrderView(isPresented: $viewModel.showSheetEditOrder, order: order)
                            }
                        }
                        ToolbarItem {
                            TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteOrder, label: "Delete Order"){
                                deleteOrder(order: order)
                                viewModel.selectedOrder = nil
                            }
                        }
                    }
                }
            }
        } detail: {
            // column Order Details
            NavigationStack(path: $detailPath) {
                if viewModel.selectedOrder != nil {
                    OrderDetailsView(
                        viewModel: viewModel,
                        actionDeleteMeeting: deleteMeeting,
                        actionUpdateMeeting: updateMeeting
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
    
    private func updateMeeting(meeting: Schedule){
        withAnimation{
            viewModel.selectedMeeting?.start = meeting.start
            viewModel.selectedMeeting?.finish = meeting.finish
            viewModel.selectedMeeting?.completed = meeting.completed
            viewModel.selectedMeeting?.cost = meeting.cost
            viewModel.selectedMeeting?.details = meeting.details
            try? modelContext.save()
        }
    }
}
