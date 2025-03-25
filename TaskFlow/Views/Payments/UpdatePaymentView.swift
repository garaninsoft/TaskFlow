//
//  UpdatePaymentView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 24.03.2025.
//

import SwiftUI

struct UpdatePaymentView: View {
    let payment: Payment
    @Binding var isPresented: Bool
    let actionUpdatePayment: (Payment)-> Void
    
    var body: some View {
        PaymentForm(
            payment: payment,
            titleForm: "Update Payment",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: actionUpdatePayment
        )
    }
}
