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
            statsCard
        }
        .padding(.horizontal)
    }
    
    // MARK: - Компоненты
    
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsRow(
                title: "Проведено занятий",
                value: "\(order.orderTotalStatistics.completedSessionsCount)/\(order.orderTotalStatistics.sessionsCount)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            StatsRow(
                title: "Общая стоимость",
                value: formattedCurrency(order.orderTotalStatistics.totalCost),
                icon: currencyIcon,
                color: .green
            )
            
            StatsRow(
                title: "Расхождение времени",
                value: order.orderTotalStatistics.totalTimeDiscrepancy,
                icon: "clock.fill",
                color: timeDiscrepancyColor
            )
            Divider()
            StatsRow(
                title: "Общая сумма платежей",
                value: formattedCurrency(order.orderTotalStatistics.totalPayments),
                icon: currencyIcon,
                color: .red
            )
            StatsRow(
                title: "Общая сумма налога",
                value: formattedCurrency(order.orderTotalStatistics.totalTax),
                icon: currencyIcon,
                color: .cyan
            )
            StatsRow(
                title: "Доход",
                value: formattedCurrency(order.orderTotalStatistics.netIncome),
                icon: currencyIcon,
                color: .green
            )
            
        }
        .padding()
    }
    
    // MARK: - Вычисляемые свойства
    
    private var timeDiscrepancyColor: Color {
        let minutes = order.totalTimeDiscrepancyInMinutes
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

// MARK: - Вспомогательные компоненты

struct StatsRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
        .font(.system(size: 16))
    }
}

struct BackgroundView: View {
    var body: some View {
        Color(.windowBackgroundColor)
    }
}

