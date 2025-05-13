//
//  StudentsListView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI

struct OrdersListView: View {
    let orders: [Order]
    @State private var selectedOrder: Order? = nil
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        if !orders.isEmpty {
            List(selection: $selectedOrder) {
                ForEach(orders) { order in
                    NavigationLink(value: order){
                        HStack {
                            Text(order.title)
                            Text(order.details)
                                .font(.system(size: 10))
                        }
                    }
                }
                .onChange(of: selectedOrder) {
                    viewModel.selectOrder(order: selectedOrder)
                }
                .onAppear{
                    selectedOrder = nil
                }
            }
        }else{
            Text("No Orders")
        }
    }
}
