//
//  SwiftUIView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

import SwiftUI

struct CreatePaymentView: View {
    var order: Order
    
    @Binding var isPresented: Bool
    let dataService: PaymentsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        PaymentForm(
            titleForm: "Create Payment",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {payment in
                dataService.create(payment: payment, for: order, onSuccess: onSuccess)
            }
        )
    }
}

