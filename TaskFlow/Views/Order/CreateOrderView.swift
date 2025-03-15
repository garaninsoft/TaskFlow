//
//  CreateOrderView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 05.03.2025.
//

import SwiftUI

struct CreateOrderView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var student: Student
    var order: Order? = nil
    
    var body: some View {
        OrderForm(
            order: order,
            titleForm: "Create Order",
            captionButtonSuccess: "Create",
            action: {order in
                student.orders?.append(order)
            }
        )
    }
}

