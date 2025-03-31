//
//  CurrencyView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 31.03.2025.
//

import SwiftUI

// Вью для отображения суммы с цветом в зависимости от значения
struct CurrencyView: View {
    let amount: Double
    
    var body: some View {
        Text(amount.formattedAsCurrency())
            .foregroundColor(textColor)
    }
    
    private var textColor: Color {
        amount < 0 ? .red : (amount > 0 ? .green : .primary)
    }
}

#Preview {
    CurrencyView(amount: 123.45)
}
