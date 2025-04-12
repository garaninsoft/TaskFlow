//
//  StatisticTotalView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 29.03.2025.
//

import SwiftUI

struct OrderStatisticTotalView: View {
    let order: Order
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок
            VStack {
                Text(order.title)
                    .font(.title2.bold())
                
                if let studentName = order.student?.name {
                    Text(studentName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top)
            
            // Основная статистика
            StatisticTotalCard(statisticTotal: order, orderCaption: "Баланс по заказу")
        }
        .padding(.horizontal)
    }
}
