//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

enum EOrderDetails: Int {
    case meetings, works, payments
}

struct OrderDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    let dataService: OrdersProtocol
    
    var body: some View {
        TabView(selection: $viewModel.selectedOrderDetailsTab) {
            MeetingsView(
                viewModel: viewModel,
                dataService: dataService
            )
            .tabItem {
                Text("Meetings")
            }
            .tag(EOrderDetails.meetings)

            WorksView(
                viewModel: viewModel,
                dataService: dataService
            )
            .tabItem {
                Text("Works")
            }
            .tag(EOrderDetails.works)
            
            PaymentsView(
                viewModel: viewModel,
                dataService: dataService
            )
            .tabItem {
                Text("Payments")
            }
            .tag(EOrderDetails.payments)
        }
        
    }
}

