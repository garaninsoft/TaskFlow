//
//  SwiftUIView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

import SwiftUI

struct CreatePaymentView: View {
    var order: Order
    let payment: Payment?
    @Binding var isPresented: Bool
    let dataService: PaymentsProtocol
    let onSuccess: () -> Void
    
    var body: some View {
        
        let temp = payment ?? Payment(details: "<От кого>@<Банк Из>#<В Банк>")
        
        PaymentForm(
            payment: temp,
            titleForm: "Create Payment",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: {payment in
                dataService.create(payment: payment, for: order, onSuccess: onSuccess)
            }
        )
    }
}

