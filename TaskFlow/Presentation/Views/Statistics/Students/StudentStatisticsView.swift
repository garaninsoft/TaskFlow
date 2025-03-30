//
//  StudentStatisticsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import SwiftUI

struct StudentStatisticsView: View {
    let student: Student
    @Binding var isPresented: Bool
    var body: some View {
        TabView{
            StudentStatisticTaxView(student: student)
            .tabItem {
                Text("Tax")
            }
            
            StudentStatisticTotalView(student: student)
            .tabItem {
                Text("Total")
            }
        }
        .padding()
        Spacer()
        
        HStack {
            Spacer()
            Button(action: { isPresented = false }) {
                Text("Закрыть")
                    .frame(minWidth: 80)
            }
            .controlSize(.large)
            .keyboardShortcut(.defaultAction)
        }
        .padding()
    }
}

