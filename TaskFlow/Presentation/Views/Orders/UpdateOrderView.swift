//
//  updateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct UpdateOrderView: View {
    var order: Order
    
    @Binding var isPresented: Bool
    let dataService: OrdersProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        OrderForm(
            order: order,
            titleForm: "Update Order",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: {order in
                dataService.update(order: order, onSuccess: onSuccess)
            }
        )
    }
}
