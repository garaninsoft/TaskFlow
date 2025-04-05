//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

enum EOrderDetails: Int {
    case meetings, works, payments, calendar
}

struct OrderDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    let ordersProtocol: OrdersProtocol
    
    var body: some View {
        TabView(selection: $viewModel.selectedOrderDetailsTab) {
            MeetingsView(
                viewModel: viewModel,
                meetingsProtocol: ordersProtocol
            )
            .tabItem {
                Text("Meetings")
            }
            .tag(EOrderDetails.meetings)
            
            WorksView(
                viewModel: viewModel,
                worksProtocol: ordersProtocol
            )
            .tabItem {
                Text("Works")
            }
            .tag(EOrderDetails.works)
            
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

