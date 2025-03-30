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
            statsCard
        }
        .padding(.horizontal)
    }
    
    // MARK: - Компоненты
    
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsRow(
                title: "Проведено занятий",
                value: "\(student.studentTotalStatistics.completedSessionsCount)/\(student.studentTotalStatistics.sessionsCount)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            StatsRow(
                title: "Общая стоимость",
                value: formattedCurrency(student.studentTotalStatistics.totalCost),
                icon: currencyIcon,
                color: .green
            )
            
            StatsRow(
                title: "Расхождение времени",
                value: student.studentTotalStatistics.totalTimeDiscrepancy,
                icon: "clock.fill",
                color: timeDiscrepancyColor
            )
            Divider()
            StatsRow(
                title: "Общая сумма платежей",
                value: formattedCurrency(student.studentTotalStatistics.totalPayments),
                icon: currencyIcon,
                color: .red
            )
            StatsRow(
                title: "Общая сумма налога",
                value: formattedCurrency(student.studentTotalStatistics.totalTax),
                icon: currencyIcon,
                color: .cyan
            )
            StatsRow(
                title: "Доход",
                value: formattedCurrency(student.studentTotalStatistics.netIncome),
                icon: currencyIcon,
                color: .green
            )
            
        }
        .padding()
    }
    
    // MARK: - Вычисляемые свойства
    
    private var timeDiscrepancyColor: Color {
        let minutes = student.totalTimeDiscrepancyInMinutes
        return minutes > 0 ? .orange : (minutes < 0 ? .red : .secondary)
    }
    
    private var currencyIcon: String {
        return "rublesign.circle.fill"
    }

    
    // MARK: - Методы
    
    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₽"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

