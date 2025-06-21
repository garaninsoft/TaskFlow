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
                            VStack{
                                Text(order.title)
                                Text(order.folderName).font(.system(size: 10))
                            }
                            Text(order.details).font(.system(size: 10))
                        }
                    }
                }
                .onChange(of: selectedOrder) {
                    viewModel.selectOrder(order: selectedOrder)
                }
                .onAppear{
                    if let order = viewModel.selectedOrder{
                        selectedOrder = order
                    }
                }
            }
        }else{
            Text("No Orders")
        }
    }
}
