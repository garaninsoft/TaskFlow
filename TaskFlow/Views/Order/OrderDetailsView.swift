//
//  OrderDetailsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 07.03.2025.
//

import SwiftUI

struct OrderDetailsView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    let actionDeleteMeeting: (Schedule) -> Void
    let actionUpdateMeeting: (Schedule) -> Void
    
    var body: some View {
        TabView {
            MeetingsView(
                viewModel: viewModel,
                actionDeleteMeeting: actionDeleteMeeting,
                actionUpdateMeeting: actionUpdateMeeting
            )
                .tabItem {
                    Text("Meetings")
                }
            
            PaymentsView(
                viewModel: viewModel, actionDeletePayment: {_ in }, actionUpdatePayment: {_ in }
            )
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

