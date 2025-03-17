//
//  updateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct UpdateOrderView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    
    var order: Order
    
    var body: some View {
        OrderForm(
            order: order,
            titleForm: "Update Order",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: updateOrder
        )
    }
    
    func updateOrder(_ order: Order){
        self.order.title = order.title
        self.order.details = order.details
        try? modelContext.save()
    }
}
