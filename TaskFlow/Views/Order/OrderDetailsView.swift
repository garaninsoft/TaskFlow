//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

enum EOrderDetails: Int {
    case meetings, payments, calendar
}

struct OrderDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    let ordersProtocol: OrdersProtocol
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            MeetingsView(
                viewModel: viewModel,
                meetingsProtocol: ordersProtocol
            )
                .tabItem {
                    Text("Meetings")
                }
                .tag(EOrderDetails.meetings)
            
            PaymentsView(
                viewModel: viewModel,
                paymentProtocol: ordersProtocol
            )
                .tabItem {
                    Text("Payments")
                }
                .tag(EOrderDetails.payments)
            
            CalendarView()
                .tabItem {
                    Text("Calendar")
                }
                .tag(EOrderDetails.calendar)
        }
    }
}

