//
//  StatisticTotalCard.swift
//  TaskFlow
//
//  Created by alexandergaranin on 31.03.2025.
//

import SwiftUI

struct StatisticTotalCard: View {
    let statisticTotal: StatisticsProtocol
    let orderCaption: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            StatsRow(
                title: "Проведено занятий",
                value: "\(statisticTotal.totalStatistics.completedSessionsCount) / \(statisticTotal.totalStatistics.sessionsCount)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            StatsRow(
                title: "На сумму",
                value: statisticTotal.totalStatistics.totalCost.formattedAsCurrency(),
                icon: currencyIcon,
                color: .green
            )
            
            StatsRow(
                title: "Баланс оплаченных занятий",
                value: statisticTotal.totalStatistics.totalPaymentsMeetings.formattedAsCurrency(),
                icon: currencyIcon,
                color: .red
            )
            
            StatsRow(
                title: "Расхождение времени",
                value: statisticTotal.totalStatistics.totalTimeDiscrepancy,
                icon: "clock.fill",
                color: timeDiscrepancyColor
            )
            
            Divider()
            StatsRow(
                title: "Прочие расходы",
                value: statisticTotal.totalStatistics.totalOtherExpenses.formattedAsCurrency(),
                icon: currencyIcon,
                color: .cyan
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

struct StatsRow<Value: CustomStringConvertible>: View {
    let title: String
    let value: Value
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            Text(title)
            Spacer()
            if let amonnt = value as? Double{
                CurrencyView(amount: amonnt)
            } else if let text = value as? String{
                Text(text)
            } else {
                Text("no data")
            }
        }
        .font(.system(size: 14))
    }
}

#Preview {
    let order = Order(title: "Order", details: "Details", created: Date())
    StatisticTotalCard(statisticTotal: order, orderCaption: "Баланс по занятиям")
}
