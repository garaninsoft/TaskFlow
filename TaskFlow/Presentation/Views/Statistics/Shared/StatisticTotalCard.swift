//
//  StatisticTotalCard.swift
//  TaskFlow
//
//  Created by alexandergaranin on 31.03.2025.
//

import SwiftUI

struct StatisticTotalCard: View {
    let statisticTotal: StatisticsProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsRow(
                title: "Проведено занятий",
                value: "\(statisticTotal.totalStatistics.completedSessionsCount)/\(statisticTotal.totalStatistics.sessionsCount)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            StatsRow(
                title: "Общая стоимость",
                value: statisticTotal.totalStatistics.totalCost.formattedAsCurrency(),
                icon: currencyIcon,
                color: .green
            )
            
            StatsRow(
                title: "Расхождение времени",
                value: statisticTotal.totalStatistics.totalTimeDiscrepancy,
                icon: "clock.fill",
                color: timeDiscrepancyColor
            )
            Divider()
            StatsRow(
                title: "Баланс платежей",
                value: statisticTotal.totalStatistics.totalPayments.formattedAsCurrency(),
                icon: currencyIcon,
                color: .red
            )
            StatsRow(
                title: "Общая сумма налога",
                value: statisticTotal.totalStatistics.totalTax.formattedAsCurrency(),
                icon: currencyIcon,
                color: .cyan
            )
            StatsRow(
                title: "Доход",
                value: statisticTotal.totalStatistics.netIncome.formattedAsCurrency(),
                icon: currencyIcon,
                color: .green
            )
            
        }
        .padding()
    }
    private var timeDiscrepancyColor: Color {
        let minutes = statisticTotal.totalTimeDiscrepancyInMinutes
        return minutes > 0 ? .orange : (minutes < 0 ? .red : .secondary)
    }
    
    private var currencyIcon: String {
        return "rublesign.circle.fill"
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
