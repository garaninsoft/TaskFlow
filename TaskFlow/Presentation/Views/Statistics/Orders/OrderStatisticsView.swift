//
//  StatisticsView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

import SwiftUI

struct OrderStatisticsView: View {
    let order: Order
    @Binding var isPresented: Bool
    var body: some View {
        TabView{
            OrderStatisticTotalView(order: order)
            .tabItem {
                Text("Total")
            }
            StatisticTaxView(statisticTaxItems: order.statisticTaxItems)
            .tabItem {
                Text("Tax")
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

#Preview {
    @Previewable @State var isPresent: Bool = false
    
    let pc1 = PaymentCategory(name: "Cat 1")
    let pc2 = PaymentCategory(name: "Cat 2")
    let pc3 = PaymentCategory(name: "Cat 3")
    
    let order = Order(
        title: "",
        details: "",
        created: Date(),
        payments: [
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: pc2, amount: 1000, declared: false, details: "", created: Date()),
            Payment(category: pc2, amount: 1000, declared: true, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: false, details: "", created: Date()),
            Payment(category: pc1, amount: -1000, declared: true, details: "", created: Date()),
            Payment(category: nil, amount: 1000, declared: true, details: "", created: Date()),
        ]
    )
    
    OrderStatisticsView(order: order, isPresented: $isPresent)
}
