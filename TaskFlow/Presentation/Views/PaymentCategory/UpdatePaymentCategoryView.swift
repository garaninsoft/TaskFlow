//
//  UpdatePaymentCategoryView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 25.03.2025.
//

import SwiftUI

struct UpdatePaymentCategoryView: View {
    let category: PaymentCategory
    @Binding var isPresented: Bool
    let action: (PaymentCategory)-> Void
    
    var body: some View {
        PaymentCategoryForm(
            category: category,
            titleForm: "Update Category",
            captionButtonSuccess: "Update",
            isPresented: $isPresented,
            action: action
        )
    }
}

