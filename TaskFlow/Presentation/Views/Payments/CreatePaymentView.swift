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

        // Подставляем данные из последнего платежа
        let temp: Payment = {
            if let lastPayment = order.payments?.last {
                return Payment(
                    amount: lastPayment.amount,
                    details: lastPayment.details
                )
            } else {
                return Payment(
                    amount: 0,
                    details: "<От кого>@<Банк Из>#<В Банк>"
                )
            }
        }()
        
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

