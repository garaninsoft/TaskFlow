//
//  StudentsTabToolbar.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI

struct OrdersToolbar: ToolbarContent {
    @ObservedObject var viewModel: MainViewModel
    let dataService: StudentsProtocol
    
    var body: some ToolbarContent {
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
}
