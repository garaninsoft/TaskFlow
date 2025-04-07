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

    
    var modelContext: ModelContext

    private var dataService: StudentsProtocol
    
    @Query(filter: #Predicate<Student> { $0.closed == nil }) private var activeStudents: [Student]
    @Query(filter: #Predicate<Student> { $0.closed != nil }) private var closedStudents: [Student]

    @ObservedObject var viewModel: MainViewModel
    
    // NavigationPath for column Order Detail
    @State private var detailPath = NavigationPath()

    init(viewModel: MainViewModel, modelContext: ModelContext) {
        self.dataService = StudentsDataService(modelContext: modelContext, viewModel: viewModel)
        self.viewModel = viewModel
        self.modelContext = modelContext
    }
    
    var body: some View {
        NavigationSplitView {
            
            TabView{
                List(selection: $viewModel.selectedStudent) {
                    ForEach(activeStudents) { student in
                        NavigationLink(student.name, value: student)
                    }
                    .onChange(of: viewModel.selectedStudent) {
                        viewModel.selectedOrder = nil
                    }
                }.tabItem {
                    Text("Open")
                }
                .onAppear{
                    viewModel.selectedStudent = nil
                    viewModel.selectedOrder = nil
                }
                
                List(selection: $viewModel.selectedStudent) {
                    ForEach(closedStudents) { student in
                        NavigationLink(student.name, value: student)
                    }
                    .onChange(of: viewModel.selectedStudent) {
                        viewModel.selectedOrder = nil
                    }
                }.tabItem {
                    Text("Closed")
                }
                .onAppear{
                    viewModel.selectedStudent = nil
                    viewModel.selectedOrder = nil
                }
            }
            
            .toolbar {
                ToolbarItem {
                    Button(action: {viewModel.showSheetNewStudent = true}) {
                        Label("Add Student", systemImage: "plus")
                    }
                    .sheet(isPresented: $viewModel.showSheetNewStudent) {
                        CreateStudentView(isPresented: $viewModel.showSheetNewStudent, dataService: dataService){}
                    }
                }
                if let student = viewModel.selectedStudent {
                    //statistics
                    ToolbarItem {
                        Button(action: {viewModel.showSheetStudentStatistics = true}) {
                            Label("Statistics", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .sheet(isPresented: $viewModel.showSheetStudentStatistics) {
                            StudentStatisticsView(student: student, isPresented: $viewModel.showSheetStudentStatistics)
                        }
                    }
                    ToolbarItem {
                        Button(action: {viewModel.showSheetEditStudent = true}) {
                            Label("Edit Student", systemImage: "pencil")
                        }
                        .sheet(isPresented: $viewModel.showSheetEditStudent) {
                            UpdateStudentView(student: student,isPresented: $viewModel.showSheetEditStudent, dataService: dataService){}
                        }
                    }
                    ToolbarItem {
                        TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteStudent, label: "Delete Student"){
                            dataService.delete(student: student){ viewModel.selectedStudent = nil }
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
                            viewModel.selectedPayment = nil
                            viewModel.selectedWork = nil
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
                            CreateOrderView(student: student, isPresented: $viewModel.showSheetNewOrder, dataService: dataService){}
                        }
                    }
                    if let order = viewModel.selectedOrder {
                        ToolbarItem {
                            Button(action: {viewModel.showSheetOrderStatistics = true}) {
                                Label("Statistics", systemImage: "chart.line.uptrend.xyaxis")
                            }
                            .sheet(isPresented: $viewModel.showSheetOrderStatistics) {
                                OrderStatisticsView(order: order, isPresented: $viewModel.showSheetOrderStatistics)
                            }
                        }
                        ToolbarItem {
                            Button(action: {viewModel.showSheetEditOrder = true}) {
                                Label("Edit Order", systemImage: "pencil")
                            }
                            .sheet(isPresented: $viewModel.showSheetEditOrder) {
                                UpdateOrderView(order: order, isPresented: $viewModel.showSheetEditOrder, dataService: dataService){}
                            }
                        }
                        ToolbarItem {
                            TrashConfirmButton(isPresent: $viewModel.showConfirmDeleteOrder, label: "Delete Order"){
                                dataService.delete(order: order){
                                    viewModel.selectedOrder = nil
                                }
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
                        dataService: dataService
                    )
                } else {
                    Text("Select Order")
                }
            }
        }
    }
}
