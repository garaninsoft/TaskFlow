//
//  Student+Calculations.swift
//  TaskFlow
//
//  Created by alexandergaranin on 30.03.2025.
//

import Foundation

extension Student {
    /// Общая сумма за все проведенные занятия
    var totalSessionsCost: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0){ $0 + $1.totalSessionsCost}
    }
    
    /// Общий перерасход/недоплата времени (в минутах)
    var totalTimeDiscrepancyInMinutes: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalTimeDiscrepancyInMinutes }
    }
    
    /// Чистый доход с учетом налога 4%
    var netIncome: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.netIncome }
    }
    
    /// Общая сумма всех платежей по заказу
    var totalPaymentsAmount: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalPaymentsAmount }
    }
    
    /// Общая сумма налогов
    var totalTax: Double {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalTax }
    }
    
    /// Завершённые (проведённые) занятия
    var completedMeetingsCount: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.completedMeetingsCount }
    }
    
    /// Всего запланированных занятий
    var totalMeetingsCount: Int {
        guard let orders = orders else { return 0 }
        return orders.reduce(0) { $0 + $1.totalMeetingsCount }
    }
    
    var statisticTaxItems: [StatisticTaxItem]{
        guard let orders = orders else { return [] }
        
        let nestedItems: [[StatisticTaxItem]] = orders.compactMap{ $0.statisticTaxItems }
        let flatItems = nestedItems.flatMap { $0 }
        let groupedItems = Dictionary(grouping: flatItems, by: \.category)
        
        let categoryTotals = groupedItems.map { category, items in
            StatisticTaxItem(
                category: category,
                declared: items.reduce(0) { $0 + $1.declared },
                undeclared: items.reduce(0) { $0 + $1.undeclared }
            )
        }
        
        return categoryTotals
    }
    
    /// Статистика по проведенным занятиям
    struct StudentStatistics {
        let totalCost: Double
        let totalPayments: Double
        let totalTimeDiscrepancy: String
        let sessionsCount: Int
        let completedSessionsCount: Int
        let netIncome: Double
        let totalTax: Double
    }
    
    /// Полная статистика по занятиям
    var studentTotalStatistics: StudentStatistics {
        return StudentStatistics(
            totalCost: totalSessionsCost,
            totalPayments: totalPaymentsAmount,
            totalTimeDiscrepancy: formattedTotalTimeDiscrepancy,
            sessionsCount: totalMeetingsCount,
            completedSessionsCount: completedMeetingsCount,
            netIncome: netIncome,
            totalTax: totalTax
        )
    }
}
