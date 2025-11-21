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
    
    // Binding напрямую берём/устанавливаем через viewModel
    private var selectionBinding: Binding<UUID?> {
        Binding<UUID?>(
            get: { viewModel.selectedOrder?.persistentId },
            set: { newId in
                let selected = orders.first(where: { $0.persistentId == newId })
                viewModel.selectOrder(order: selected)
            }
        )
    }
    
    var body: some View {
        if !orders.isEmpty {
            List(selection: selectionBinding) {
                ForEach(orders) { order in
                    NavigationLink(value: order) {
                        HStack{
                            VStack(alignment: .leading) {
                                Text(order.title)
                                Text(order.details).font(.system(size: 10))
                            }
                            Spacer()
                            if let agent = order.agent {
                                if !agent.isEmpty{
                                    VStack(alignment: .leading){
                                        Text(agent)
                                            .fontWeight(.bold)
                                        Text("комиссия: \(order.commission?.formattedAsCurrency() ?? "")")
                                        Text("до: \(order.feedealine?.formatted(.shortDate) ?? "")")
                                    }
                                    .font(.system(size: 10))
                                    .padding(4)
                                    .frame(width: 150, alignment: .leading)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(6)
                                }
                            }
                        }
                    }
                    .tag(order.persistentId)
                }
            }
        } else {
            Text("No Orders")
        }
    }
}
