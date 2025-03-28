//
//  StatisticsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

import SwiftUI

struct StatisticsView: View {
    let order: Order
    @Binding var isPresented: Bool
    var body: some View {
        TabView{
            StatisticTaxView(
                order: order, isPresented: $isPresented)
            .tabItem {
                Text("Tax")
            }
            
            StatisticTaxView(
                order: order, isPresented: $isPresented)
            .tabItem {
                Text("Total")
            }
            
        }
        
    }
}
