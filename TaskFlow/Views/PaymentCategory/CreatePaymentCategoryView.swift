//
//  CreatePaymentCategoryView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 25.03.2025.
//

import SwiftUI

struct CreatePaymentCategoryView: View {

    @Binding var isPresented: Bool
    let action: (PaymentCategory) -> Void
    var body: some View {
        PaymentCategoryForm(
            titleForm: "Create Category",
            captionButtonSuccess: "Create",
            isPresented: $isPresented,
            action: action
        )
    }
}

