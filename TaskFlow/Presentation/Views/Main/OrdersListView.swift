//
//  StudentsListView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 12.05.2025.
//

import SwiftUI


struct OrdersListView: View {
    let orders: [Order]
    @State private var selectedOrderID: UUID?
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        if !orders.isEmpty {
            List(selection: $selectedOrderID) {
                ForEach(orders) { order in
                    NavigationLink(value: order) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(order.title)
                                Text(order.details).font(.system(size: 10))
                            }
                            Spacer()
                            if let agent = order.agent {
                                VStack(alignment: .leading){
                                    Text(agent)
                                        .fontWeight(.bold)
                                    Text(order.commission?.formattedAsCurrency() ?? "N/A")
                                    Text(order.feedealine?.formatted(.shortDate) ?? "N/A")
                                }
                                .font(.system(size: 10))
                                .padding(4)
                                .background(Color.gray.opacity(0.15))
                                .cornerRadius(6)
                            }
                        }
                    }
                    .tag(order.persistentId)
                }
            }
            .onChange(of: selectedOrderID) {
                let selected = orders.first(where: { $0.persistentId == selectedOrderID })
                viewModel.selectOrder(order: selected)
            }
            .onAppear {
                selectedOrderID = viewModel.selectedOrder?.persistentId
            }
        } else {
            Text("No Orders")
        }
    }
}
