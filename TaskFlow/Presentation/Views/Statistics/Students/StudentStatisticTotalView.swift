//
//  OrderStatisticTotalView.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import SwiftUI

struct StudentStatisticTotalView: View {
    let student: Student
    
    var body: some View {
        VStack(spacing: 20) {
            // Заголовок

            Text(student.name)
                .font(.title2.bold())
                .padding(.top)
            
            // Основная статистика
            StatisticTotalCard(statisticTotal: student, orderCaption: "Баланс по заказам")
        }
        .padding(.horizontal)
    }
}

