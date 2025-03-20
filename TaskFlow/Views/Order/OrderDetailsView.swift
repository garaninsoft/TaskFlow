//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

struct OrderDetailsView: View {
    var order: Order
    
    let headers = ["Name", "Age", "City"]
    let data1 = [
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"]
    ]
    let data2 = [
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"],
        ["Alice", "30", "New York"],
        ["Bob", "25", "London"],
        ["Charlie", "40", "Paris"],
        ["David", "35", "Tokyo"]
    ]
    
    let columnWidths: [CGFloat] = [100, 50, 120] // Задаем ширину столбцов
    
    var body: some View {
        TabView {
            MeetingsView()
                .tabItem {
                    Text("Meetings")
                }
            
            PaymentsView(headers: headers, data: data2, columnWidths: columnWidths)
                .tabItem {
                    Text("Payments")
                }
            
            CalendarView()
                .tabItem {
                    Text("Calendar")
                }
        }
    }
}

