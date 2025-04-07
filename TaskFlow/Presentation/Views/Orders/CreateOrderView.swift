//
//  CreateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct CreateOrderView: View {
    var student: Student
    
    @Binding var isPresented: Bool
    let dataService: OrdersProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        OrderForm(
            titleForm: "Create Order",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {order in
                dataService.create(order: order, for: student, onSuccess: onSuccess)
            }
        )
    }
}

