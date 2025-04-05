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
    @Binding var isPresented: Bool
    
    var body: some View {
        OrderForm(
            titleForm: "Create Order",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {order in
                student.orders?.append(order)
            }
        )
    }
}

