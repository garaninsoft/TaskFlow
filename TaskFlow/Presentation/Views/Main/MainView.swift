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
                StudentsListView(
                    students: activeStudents,
                    viewModel: viewModel
                )
                .tabItem {
                    Text("Open")
                }
                
                StudentsListView(
                    students: closedStudents,
                    viewModel: viewModel
                )
                .tabItem {
                    Text("Closed")
                }
            }
            .toolbar {
                StudentsToolbar(viewModel: viewModel, dataService: dataService)
            }
        } content:{
            // column Orders
            NavigationStack{
                if let student = viewModel.selectedStudent {
                    OrdersListView(orders: student.orders ?? [], viewModel: viewModel)
                } else {
                    Text("Select Student")
                }
            }
            .navigationTitle("Orders")
            .toolbar {
                OrdersToolbar(viewModel: viewModel, dataService: dataService)
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
