//
//  StudentsTabToolbar.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI

struct StudentsToolbar: ToolbarContent {
    @ObservedObject var viewModel: MainViewModel
    let dataService: StudentsProtocol
    
    var body: some ToolbarContent {
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
}
