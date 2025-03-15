//
//  updateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct UpdateOrderView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var order: Order
    
    var body: some View {
        OrderForm(
            order: order,
            titleForm: "Update Order",
            captionButtonSuccess: "Update",
            action: updateOrder
        )
    }
    
    func updateOrder(_ order: Order){
        self.order.details = order.details
        try? modelContext.save()
    }
}
