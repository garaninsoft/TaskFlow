//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

struct OrderDetailsView: View {
    
    let order: Order
    @Binding var selectedMeeting: Schedule?
    @Binding var showSheetNewMeeting: Bool
    @Binding var showSheetEditMeeting: Bool
    @Binding var showConfirmDeleteMeeting: Bool
    
    let actionDeleteMeeting: (Schedule) -> Void
    let actionUpdateMeeting: (Schedule) -> Void
    
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
            MeetingsView(
                order: order,
                selectedMeeting: $selectedMeeting,
                showSheetNewMeeting: $showSheetNewMeeting,
                showSheetEditMeeting: $showSheetEditMeeting,
                showConfirmDeleteMeeting: $showConfirmDeleteMeeting,
                actionDeleteMeeting: actionDeleteMeeting,
                actionUpdateMeeting: actionUpdateMeeting
            )
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

